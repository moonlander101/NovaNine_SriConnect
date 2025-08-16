import { useState, useEffect, useCallback } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Alert, AlertDescription } from "@/components/ui/alert";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { Avatar, AvatarFallback } from "@/components/ui/avatar";
import { 
  Plus, 
  Search, 
  Mail, 
  Phone, 
  User, 
  Shield, 
  Edit,
  Trash2,
  Users as UsersIcon
} from "lucide-react";
import { usersApi } from "@/services/usersApi";
import type { AppUser, UserRole } from "@/types/database";

const Users = () => {
  const [users, setUsers] = useState<AppUser[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedRole, setSelectedRole] = useState<string>("all");
  const [isAddDialogOpen, setIsAddDialogOpen] = useState(false);
  const [editingUser, setEditingUser] = useState<AppUser | null>(null);
  const [deletingUser, setDeletingUser] = useState<AppUser | null>(null);

  const [newUser, setNewUser] = useState({
    full_name: "",
    nic_no: "",
    email: "",
    phone_no: "",
    role: "Citizen" as UserRole
  });

  const loadUsers = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      
      console.log('🔍 Loading users...');
      const usersData = await usersApi.getAll();
      console.log('✅ Users loaded:', usersData);
      setUsers(usersData);
    } catch (err) {
      console.error('❌ Failed to load users:', err);
      setError(err instanceof Error ? err.message : 'Failed to load users');
    } finally {
      setLoading(false);
    }
  }, []);

  // Load users on component mount
  useEffect(() => {
    loadUsers();
  }, [loadUsers]);

  // Filter users based on search term and role
  const filteredUsers = users.filter(user => {
    const matchesSearch = !searchTerm || 
      user.full_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
      user.nic_no.toLowerCase().includes(searchTerm.toLowerCase());
    
    const matchesRole = selectedRole === "all" || user.role === selectedRole;
    
    return matchesSearch && matchesRole;
  });

  const handleCreateUser = async () => {
    try {
      setError(null);
      console.log('🔍 Creating user:', newUser);
      
      const createdUser = await usersApi.create(newUser);
      console.log('✅ User created:', createdUser);
      
      setUsers(prev => [createdUser, ...prev]);
      setIsAddDialogOpen(false);
      setNewUser({
        full_name: "",
        nic_no: "",
        email: "",
        phone_no: "",
        role: "Citizen"
      });
    } catch (err) {
      console.error('❌ Failed to create user:', err);
      setError(err instanceof Error ? err.message : 'Failed to create user');
    }
  };

  const handleUpdateUser = async () => {
    if (!editingUser) return;
    
    try {
      setError(null);
      console.log('🔍 Updating user:', editingUser);
      
      const updatedUser = await usersApi.update(editingUser.user_id, {
        full_name: editingUser.full_name,
        nic_no: editingUser.nic_no,
        email: editingUser.email,
        phone_no: editingUser.phone_no,
        role: editingUser.role
      });
      
      console.log('✅ User updated:', updatedUser);
      
      setUsers(prev => prev.map(user => 
        user.user_id === updatedUser.user_id ? updatedUser : user
      ));
      setEditingUser(null);
    } catch (err) {
      console.error('❌ Failed to update user:', err);
      setError(err instanceof Error ? err.message : 'Failed to update user');
    }
  };

  const handleDeleteUser = async () => {
    if (!deletingUser) return;
    
    try {
      setError(null);
      console.log('🔍 Deleting user:', deletingUser);
      
      await usersApi.delete(deletingUser.user_id);
      console.log('✅ User deleted');
      
      setUsers(prev => prev.filter(user => user.user_id !== deletingUser.user_id));
      setDeletingUser(null);
    } catch (err) {
      console.error('❌ Failed to delete user:', err);
      setError(err instanceof Error ? err.message : 'Failed to delete user');
    }
  };

  const getRoleBadgeColor = (role: UserRole) => {
    switch (role) {
      case 'Admin': return 'bg-red-100 text-red-800';
      case 'Officer': return 'bg-blue-100 text-blue-800';
      case 'Citizen': return 'bg-green-100 text-green-800';
      default: return 'bg-gray-100 text-gray-800';
    }
  };

  const getInitials = (name: string) => {
    return name
      .split(' ')
      .map(word => word.charAt(0))
      .join('')
      .toUpperCase()
      .slice(0, 2);
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto mb-4"></div>
          <p>Loading users...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold tracking-tight">Users</h1>
          <p className="text-muted-foreground">
            Manage system users and their roles
          </p>
        </div>
        <Dialog open={isAddDialogOpen} onOpenChange={setIsAddDialogOpen}>
          <DialogTrigger asChild>
            <Button>
              <Plus className="mr-2 h-4 w-4" />
              Add User
            </Button>
          </DialogTrigger>
          <DialogContent className="max-w-md">
            <DialogHeader>
              <DialogTitle>Add New User</DialogTitle>
              <DialogDescription>
                Create a new user account in the system.
              </DialogDescription>
            </DialogHeader>
            <div className="space-y-4">
              <div>
                <Label htmlFor="fullName">Full Name</Label>
                <Input
                  id="fullName"
                  value={newUser.full_name}
                  onChange={(e) => setNewUser({...newUser, full_name: e.target.value})}
                  placeholder="Enter full name"
                />
              </div>
              <div>
                <Label htmlFor="nicNo">NIC Number</Label>
                <Input
                  id="nicNo"
                  value={newUser.nic_no}
                  onChange={(e) => setNewUser({...newUser, nic_no: e.target.value})}
                  placeholder="Enter NIC number"
                />
              </div>
              <div>
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  value={newUser.email}
                  onChange={(e) => setNewUser({...newUser, email: e.target.value})}
                  placeholder="Enter email address"
                />
              </div>
              <div>
                <Label htmlFor="phone">Phone Number</Label>
                <Input
                  id="phone"
                  value={newUser.phone_no}
                  onChange={(e) => setNewUser({...newUser, phone_no: e.target.value})}
                  placeholder="Enter phone number"
                />
              </div>
              <div>
                <Label htmlFor="role">Role</Label>
                <Select value={newUser.role} onValueChange={(value: UserRole) => setNewUser({...newUser, role: value})}>
                  <SelectTrigger>
                    <SelectValue placeholder="Select role" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Citizen">Citizen</SelectItem>
                    <SelectItem value="Officer">Officer</SelectItem>
                    <SelectItem value="Admin">Admin</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}
              <div className="flex justify-end space-x-2">
                <Button variant="outline" onClick={() => setIsAddDialogOpen(false)}>
                  Cancel
                </Button>
                <Button onClick={handleCreateUser}>Create User</Button>
              </div>
            </div>
          </DialogContent>
        </Dialog>
      </div>

      {/* Stats Cards */}
      <div className="grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total Users</CardTitle>
            <UsersIcon className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{users.length}</div>
            <p className="text-xs text-muted-foreground">
              Registered users
            </p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Administrators</CardTitle>
            <Shield className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {users.filter(u => u.role === 'Admin').length}
            </div>
            <p className="text-xs text-muted-foreground">
              Admin users
            </p>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Officers</CardTitle>
            <User className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {users.filter(u => u.role === 'Officer').length}
            </div>
            <p className="text-xs text-muted-foreground">
              Officer users
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Filters and Search */}
      <Card>
        <CardHeader>
          <CardTitle>Users</CardTitle>
          <CardDescription>
            Total users: {filteredUsers.length}
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="flex space-x-4 mb-6">
            <div className="flex-1">
              <div className="relative">
                <Search className="absolute left-2 top-2.5 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder="Search by name, email, or NIC..."
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                  className="pl-8"
                />
              </div>
            </div>
            <Select value={selectedRole} onValueChange={setSelectedRole}>
              <SelectTrigger className="w-[200px]">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="all">All Roles</SelectItem>
                <SelectItem value="Admin">Admin</SelectItem>
                <SelectItem value="Officer">Officer</SelectItem>
                <SelectItem value="Citizen">Citizen</SelectItem>
              </SelectContent>
            </Select>
          </div>

          <div className="rounded-md border">
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>User</TableHead>
                  <TableHead>Contact</TableHead>
                  <TableHead>NIC</TableHead>
                  <TableHead>Role</TableHead>
                  <TableHead>Created</TableHead>
                  <TableHead className="text-right">Actions</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {filteredUsers.map((user) => (
                  <TableRow key={user.user_id}>
                    <TableCell className="font-medium">
                      <div className="flex items-center space-x-3">
                        <Avatar>
                          <AvatarFallback>
                            {getInitials(user.full_name)}
                          </AvatarFallback>
                        </Avatar>
                        <div>
                          <div className="font-medium">{user.full_name}</div>
                          <div className="text-sm text-muted-foreground">
                            ID: {user.user_id}
                          </div>
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>
                      <div className="space-y-1">
                        <div className="flex items-center text-sm">
                          <Mail className="mr-1 h-3 w-3" />
                          {user.email}
                        </div>
                        <div className="flex items-center text-sm text-muted-foreground">
                          <Phone className="mr-1 h-3 w-3" />
                          {user.phone_no}
                        </div>
                      </div>
                    </TableCell>
                    <TableCell>{user.nic_no}</TableCell>
                    <TableCell>
                      <Badge className={getRoleBadgeColor(user.role)}>
                        <Shield className="mr-1 h-3 w-3" />
                        {user.role}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      {new Date(user.created_at).toLocaleDateString()}
                    </TableCell>
                    <TableCell className="text-right">
                      <div className="flex justify-end space-x-2">
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => setEditingUser(user)}
                        >
                          <Edit className="h-4 w-4" />
                        </Button>
                        <Button
                          variant="outline"
                          size="sm"
                          onClick={() => setDeletingUser(user)}
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </TableCell>
                  </TableRow>
                ))}
                {filteredUsers.length === 0 && (
                  <TableRow>
                    <TableCell colSpan={6} className="text-center py-8">
                      <div className="text-muted-foreground">
                        <UsersIcon className="mx-auto h-8 w-8 mb-2" />
                        {searchTerm || selectedRole !== "all" 
                          ? "No users found matching your criteria" 
                          : "No users found"}
                      </div>
                    </TableCell>
                  </TableRow>
                )}
              </TableBody>
            </Table>
          </div>
        </CardContent>
      </Card>

      {/* Edit User Dialog */}
      <Dialog open={!!editingUser} onOpenChange={() => setEditingUser(null)}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Edit User</DialogTitle>
            <DialogDescription>
              Update user information.
            </DialogDescription>
          </DialogHeader>
          {editingUser && (
            <div className="space-y-4">
              <div>
                <Label htmlFor="editFullName">Full Name</Label>
                <Input
                  id="editFullName"
                  value={editingUser.full_name}
                  onChange={(e) => setEditingUser({...editingUser, full_name: e.target.value})}
                />
              </div>
              <div>
                <Label htmlFor="editNicNo">NIC Number</Label>
                <Input
                  id="editNicNo"
                  value={editingUser.nic_no}
                  onChange={(e) => setEditingUser({...editingUser, nic_no: e.target.value})}
                />
              </div>
              <div>
                <Label htmlFor="editEmail">Email</Label>
                <Input
                  id="editEmail"
                  type="email"
                  value={editingUser.email}
                  onChange={(e) => setEditingUser({...editingUser, email: e.target.value})}
                />
              </div>
              <div>
                <Label htmlFor="editPhone">Phone Number</Label>
                <Input
                  id="editPhone"
                  value={editingUser.phone_no}
                  onChange={(e) => setEditingUser({...editingUser, phone_no: e.target.value})}
                />
              </div>
              <div>
                <Label htmlFor="editRole">Role</Label>
                <Select value={editingUser.role} onValueChange={(value: UserRole) => setEditingUser({...editingUser, role: value})}>
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="Citizen">Citizen</SelectItem>
                    <SelectItem value="Officer">Officer</SelectItem>
                    <SelectItem value="Admin">Admin</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}
              <div className="flex justify-end space-x-2">
                <Button variant="outline" onClick={() => setEditingUser(null)}>
                  Cancel
                </Button>
                <Button onClick={handleUpdateUser}>Update User</Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {/* Delete User Dialog */}
      <Dialog open={!!deletingUser} onOpenChange={() => setDeletingUser(null)}>
        <DialogContent className="max-w-md">
          <DialogHeader>
            <DialogTitle>Delete User</DialogTitle>
            <DialogDescription>
              Are you sure you want to delete this user? This action cannot be undone.
            </DialogDescription>
          </DialogHeader>
          {deletingUser && (
            <div className="space-y-4">
              <div className="bg-muted p-4 rounded-lg">
                <div className="flex items-center space-x-3">
                  <Avatar>
                    <AvatarFallback>
                      {getInitials(deletingUser.full_name)}
                    </AvatarFallback>
                  </Avatar>
                  <div>
                    <div className="font-medium">{deletingUser.full_name}</div>
                    <div className="text-sm text-muted-foreground">{deletingUser.email}</div>
                    <Badge className={getRoleBadgeColor(deletingUser.role)}>
                      {deletingUser.role}
                    </Badge>
                  </div>
                </div>
              </div>
              {error && (
                <Alert variant="destructive">
                  <AlertDescription>{error}</AlertDescription>
                </Alert>
              )}
              <div className="flex justify-end space-x-2">
                <Button variant="outline" onClick={() => setDeletingUser(null)}>
                  Cancel
                </Button>
                <Button variant="destructive" onClick={handleDeleteUser}>
                  Delete User
                </Button>
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>

      {error && !isAddDialogOpen && !editingUser && !deletingUser && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}
    </div>
  );
};

export default Users;
