<?php

namespace App\Http\Controllers;

use App\Models\Role;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\View\View;

class UserController extends Controller
{
    public function index(Request $request): View
    {
        $filters = $request->validate([
            'search' => ['nullable', 'string', 'max:80'],
            'status' => ['nullable', 'in:all,active,inactive'],
        ]);
        $usersQuery = User::with('roles')
            ->when($filters['search'] ?? null, fn ($query, $search) => $query->where(fn ($nested) => $nested
                ->where('name', 'like', "%{$search}%")
                ->orWhere('username', 'like', "%{$search}%")
                ->orWhere('email', 'like', "%{$search}%")))
            ->when(($filters['status'] ?? 'all') === 'active', fn ($query) => $query->where('is_active', true))
            ->when(($filters['status'] ?? 'all') === 'inactive', fn ($query) => $query->where('is_active', false));

        return view('users.index', [
            'users' => $usersQuery->orderBy('name')->paginate(12)->withQueryString(),
            'roles' => Role::orderBy('name')->get(),
            'filters' => $filters + ['status' => 'all'],
            'activeCount' => User::where('is_active', true)->count(),
            'inactiveCount' => User::where('is_active', false)->count(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $this->validated($request);
        $user = User::create([...$data, 'password' => Hash::make($data['password'])]);
        $user->roles()->sync($data['role_ids']);

        return back()->with('success', 'Usuario registrado.');
    }

    public function update(Request $request, User $user): RedirectResponse
    {
        $data = $this->validated($request, $user);
        if ($request->user()->is($user) && ! $data['is_active']) {
            throw ValidationException::withMessages(['is_active' => 'No puede desactivar su propia cuenta.']);
        }

        $administratorRole = Role::where('name', 'Administrador')->first();
        $isAdministrator = $administratorRole && $user->roles()->whereKey($administratorRole->id)->exists();
        $willRemainAdministrator = $administratorRole && in_array($administratorRole->id, array_map('intval', $data['role_ids']), true);
        if ($isAdministrator && (! $data['is_active'] || ! $willRemainAdministrator)) {
            $anotherActiveAdministratorExists = User::where('is_active', true)
                ->where('id', '!=', $user->id)
                ->whereHas('roles', fn ($query) => $query->where('roles.id', $administratorRole->id))
                ->exists();
            if (! $anotherActiveAdministratorExists) {
                throw ValidationException::withMessages(['role_ids' => 'Debe quedar al menos un administrador activo en el sistema.']);
            }
        }

        if (blank($data['password'])) {
            unset($data['password']);
        } else {
            $data['password'] = Hash::make($data['password']);
        }
        $user->update($data);
        $user->roles()->sync($data['role_ids']);

        return back()->with('success', 'Usuario actualizado.');
    }

    private function validated(Request $request, ?User $user = null): array
    {
        return $request->validate(['name' => ['required', 'string', 'max:150'], 'username' => ['required', 'string', 'max:50', 'unique:users,username,'.($user?->id ?? '')], 'email' => ['required', 'email', 'max:150', 'unique:users,email,'.($user?->id ?? '')], 'password' => [$user ? 'nullable' : 'required', 'string', 'min:8'], 'is_active' => ['required', 'boolean'], 'role_ids' => ['required', 'array', 'min:1'], 'role_ids.*' => ['distinct', 'exists:roles,id']]);
    }
}
