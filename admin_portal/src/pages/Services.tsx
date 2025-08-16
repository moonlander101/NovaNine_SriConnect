import React, { useState, useEffect, useCallback } from 'react'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Badge } from "@/components/ui/badge"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Textarea } from "@/components/ui/textarea"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Plus, Edit, Trash2, Building2 } from "lucide-react"
import { servicesApi, ServiceWithDepartment, CreateServiceData, UpdateServiceData } from '@/services/servicesApi'
import type { Department } from '@/types/database'

export default function Services() {
  const [services, setServices] = useState<ServiceWithDepartment[]>([])
  const [departments, setDepartments] = useState<Department[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [isCreateDialogOpen, setIsCreateDialogOpen] = useState(false)
  const [isEditDialogOpen, setIsEditDialogOpen] = useState(false)
  const [editingService, setEditingService] = useState<ServiceWithDepartment | null>(null)
  const [formData, setFormData] = useState<CreateServiceData>({
    department_id: 0,
    title: '',
    description: ''
  })

  const loadServices = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await servicesApi.getAll()
      setServices(data)
    } catch (err) {
      console.error('Error loading services:', err)
      setError('Failed to load services')
    } finally {
      setLoading(false)
    }
  }, [])

  const loadDepartments = useCallback(async () => {
    try {
      const data = await servicesApi.getDepartments()
      setDepartments(data)
    } catch (err) {
      console.error('Error loading departments:', err)
    }
  }, [])

  useEffect(() => {
    loadServices()
    loadDepartments()
  }, [loadServices, loadDepartments])

  const handleCreateService = async () => {
    try {
      if (!formData.title || !formData.department_id) {
        setError('Please fill in all required fields')
        return
      }
      
      await servicesApi.create(formData)
      await loadServices()
      setIsCreateDialogOpen(false)
      setFormData({ department_id: 0, title: '', description: '' })
      setError(null)
    } catch (err) {
      console.error('Error creating service:', err)
      setError('Failed to create service')
    }
  }

  const handleEditService = (service: ServiceWithDepartment) => {
    setEditingService(service)
    setFormData({
      department_id: service.department_id || 0,
      title: service.title,
      description: service.description || ''
    })
    setIsEditDialogOpen(true)
    setError(null)
  }

  const handleUpdateService = async () => {
    try {
      if (!editingService || !formData.title || !formData.department_id) {
        setError('Please fill in all required fields')
        return
      }
      
      await servicesApi.update(editingService.service_id, formData)
      await loadServices()
      setIsEditDialogOpen(false)
      setEditingService(null)
      setFormData({ department_id: 0, title: '', description: '' })
      setError(null)
    } catch (err) {
      console.error('Error updating service:', err)
      setError('Failed to update service')
    }
  }

  const handleDeleteService = async (serviceId: number) => {
    try {
      if (confirm('Are you sure you want to delete this service?')) {
        await servicesApi.delete(serviceId)
        await loadServices()
      }
    } catch (err) {
      console.error('Error deleting service:', err)
      setError('Failed to delete service')
    }
  }

  const resetForm = () => {
    setFormData({ department_id: 0, title: '', description: '' })
    setError(null)
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg">Loading services...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-3xl font-bold">Services Management</h1>
          <p className="text-gray-600 mt-1">Manage department services and offerings</p>
        </div>
        <Button 
          onClick={() => {
            resetForm()
            setIsCreateDialogOpen(true)
          }}
          className="bg-blue-600 hover:bg-blue-700"
        >
          <Plus className="w-4 h-4 mr-2" />
          Add Service
        </Button>
      </div>

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      {/* Services Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {services.map((service) => (
          <Card key={service.service_id} className="hover:shadow-lg transition-shadow">
            <CardHeader>
              <div className="flex justify-between items-start">
                <div className="flex-1">
                  <CardTitle className="text-lg">{service.title}</CardTitle>
                  <CardDescription className="mt-1">
                    {service.description || 'No description available'}
                  </CardDescription>
                </div>
                <div className="flex gap-2">
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => handleEditService(service)}
                  >
                    <Edit className="w-4 h-4" />
                  </Button>
                  <Button
                    variant="outline"
                    size="sm"
                    onClick={() => handleDeleteService(service.service_id)}
                  >
                    <Trash2 className="w-4 h-4" />
                  </Button>
                </div>
              </div>
            </CardHeader>
            <CardContent>
              <div className="space-y-2">
                <div className="flex items-center gap-2">
                  <Building2 className="w-4 h-4 text-gray-500" />
                  <span className="text-sm text-gray-600">
                    {service.department?.title || 'No department assigned'}
                  </span>
                </div>
                {service.department?.description && (
                  <p className="text-xs text-gray-500">
                    {service.department.description}
                  </p>
                )}
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {services.length === 0 && (
        <Card>
          <CardContent className="text-center py-8">
            <p className="text-gray-500">No services found. Create your first service to get started.</p>
          </CardContent>
        </Card>
      )}

      {/* Create Service Dialog */}
      <Dialog open={isCreateDialogOpen} onOpenChange={setIsCreateDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Create New Service</DialogTitle>
            <DialogDescription>
              Add a new service to your organization
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="create-title">Service Title *</Label>
              <Input
                id="create-title"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                placeholder="Enter service title"
              />
            </div>
            <div>
              <Label htmlFor="create-department">Department *</Label>
              <Select
                value={formData.department_id.toString()}
                onValueChange={(value) => setFormData({ ...formData, department_id: parseInt(value) })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select a department" />
                </SelectTrigger>
                <SelectContent>
                  {departments.map((dept) => (
                    <SelectItem key={dept.department_id} value={dept.department_id.toString()}>
                      {dept.title}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label htmlFor="create-description">Description</Label>
              <Textarea
                id="create-description"
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                placeholder="Enter service description"
              />
            </div>
          </div>
          <DialogFooter>
            <Button 
              variant="outline" 
              onClick={() => {
                setIsCreateDialogOpen(false)
                resetForm()
              }}
            >
              Cancel
            </Button>
            <Button onClick={handleCreateService}>
              Create Service
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Edit Service Dialog */}
      <Dialog open={isEditDialogOpen} onOpenChange={setIsEditDialogOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Edit Service</DialogTitle>
            <DialogDescription>
              Update service information
            </DialogDescription>
          </DialogHeader>
          <div className="space-y-4">
            <div>
              <Label htmlFor="edit-title">Service Title *</Label>
              <Input
                id="edit-title"
                value={formData.title}
                onChange={(e) => setFormData({ ...formData, title: e.target.value })}
                placeholder="Enter service title"
              />
            </div>
            <div>
              <Label htmlFor="edit-department">Department *</Label>
              <Select
                value={formData.department_id.toString()}
                onValueChange={(value) => setFormData({ ...formData, department_id: parseInt(value) })}
              >
                <SelectTrigger>
                  <SelectValue placeholder="Select a department" />
                </SelectTrigger>
                <SelectContent>
                  {departments.map((dept) => (
                    <SelectItem key={dept.department_id} value={dept.department_id.toString()}>
                      {dept.title}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label htmlFor="edit-description">Description</Label>
              <Textarea
                id="edit-description"
                value={formData.description}
                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                placeholder="Enter service description"
              />
            </div>
          </div>
          <DialogFooter>
            <Button 
              variant="outline" 
              onClick={() => {
                setIsEditDialogOpen(false)
                setEditingService(null)
                resetForm()
              }}
            >
              Cancel
            </Button>
            <Button onClick={handleUpdateService}>
              Update Service
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
