import React, { useState, useEffect, useCallback } from 'react'
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select"
import { Alert, AlertDescription } from "@/components/ui/alert"
import { Separator } from "@/components/ui/separator"
import { format } from 'date-fns'
import { appointmentsApi } from '@/services/appointmentsApi'
import type { AppointmentWithDetails, AppointmentStatus } from '@/types/database'

export default function Bookings() {
  const [appointments, setAppointments] = useState<AppointmentWithDetails[]>([])
  const [filteredAppointments, setFilteredAppointments] = useState<AppointmentWithDetails[]>([])
  const [searchQuery, setSearchQuery] = useState('')
  const [statusFilter, setStatusFilter] = useState<AppointmentStatus | 'all'>('all')
  const [selectedAppointment, setSelectedAppointment] = useState<AppointmentWithDetails | null>(null)
  const [isDetailDialogOpen, setIsDetailDialogOpen] = useState(false)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [stats, setStats] = useState<{
    total: number
    pending: number
    confirmed: number
    completed: number
    cancelled: number
  }>({
    total: 0,
    pending: 0,
    confirmed: 0,
    completed: 0,
    cancelled: 0
  })

  const loadAppointments = useCallback(async () => {
    try {
      setLoading(true)
      setError(null)
      const data = await appointmentsApi.getAll()
      setAppointments(data)
      setFilteredAppointments(data)
      
      // Calculate stats - using capitalized status values
      const statsData = {
        total: data.length,
        pending: data.filter(a => a.status === 'Pending').length,
        confirmed: data.filter(a => a.status === 'Confirmed').length,
        completed: data.filter(a => a.status === 'Completed').length,
        cancelled: data.filter(a => a.status === 'Cancelled').length
      }
      setStats(statsData)
    } catch (err) {
      console.error('Error loading appointments:', err)
      setError('Failed to load appointments')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    loadAppointments()
  }, [loadAppointments])

  useEffect(() => {
    let filtered = appointments

    if (searchQuery) {
      filtered = filtered.filter(
        appointment =>
          appointment.citizen?.full_name?.toLowerCase().includes(searchQuery.toLowerCase()) ||
          appointment.citizen?.nic_no?.toLowerCase().includes(searchQuery.toLowerCase()) ||
          appointment.service?.title?.toLowerCase().includes(searchQuery.toLowerCase())
      )
    }

    if (statusFilter !== 'all') {
      filtered = filtered.filter(appointment => appointment.status === statusFilter)
    }

    setFilteredAppointments(filtered)
  }, [appointments, searchQuery, statusFilter])

  const handleAppointmentClick = (appointment: AppointmentWithDetails) => {
    setSelectedAppointment(appointment)
    setIsDetailDialogOpen(true)
  }

  const handleStatusUpdate = async (appointmentId: number, newStatus: AppointmentStatus) => {
    try {
      await appointmentsApi.updateStatus(appointmentId, newStatus)
      await loadAppointments()
      setIsDetailDialogOpen(false)
    } catch (err) {
      console.error('Error updating appointment status:', err)
      setError('Failed to update appointment status')
    }
  }

  const getStatusColor = (status: AppointmentStatus) => {
    switch (status) {
      case 'Pending':
        return 'bg-yellow-500'
      case 'Confirmed':
        return 'bg-blue-500'
      case 'Completed':
        return 'bg-green-500'
      case 'Cancelled':
        return 'bg-red-500'
      default:
        return 'bg-gray-500'
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg">Loading appointments...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h1 className="text-3xl font-bold">Appointments</h1>
      </div>

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-5 gap-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Total</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{stats.total}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Pending</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">{stats.pending}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Confirmed</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-blue-600">{stats.confirmed}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Completed</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">{stats.completed}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-sm font-medium">Cancelled</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-red-600">{stats.cancelled}</div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex gap-4">
        <Input
          placeholder="Search by citizen name, NIC, or service..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="max-w-sm"
        />
        <Select
          value={statusFilter}
          onValueChange={(value) => setStatusFilter(value as AppointmentStatus | 'all')}
        >
          <SelectTrigger className="w-[180px]">
            <SelectValue placeholder="Filter by status" />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">All Statuses</SelectItem>
            <SelectItem value="Pending">Pending</SelectItem>
            <SelectItem value="Confirmed">Confirmed</SelectItem>
            <SelectItem value="Completed">Completed</SelectItem>
            <SelectItem value="Cancelled">Cancelled</SelectItem>
          </SelectContent>
        </Select>
      </div>

      {/* Appointments Table */}
      <Card>
        <CardHeader>
          <CardTitle>Appointments</CardTitle>
          <CardDescription>
            Manage citizen appointments and their status
          </CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Date & Time</TableHead>
                <TableHead>Citizen</TableHead>
                <TableHead>Service</TableHead>
                <TableHead>Officer</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Actions</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredAppointments.map((appointment) => (
                <TableRow key={appointment.appointment_id}>
                  <TableCell>
                    <div>
                      <div className="font-medium">
                        {appointment.timeslot ? format(new Date(), 'MMM dd, yyyy') : 'N/A'}
                      </div>
                      <div className="text-sm text-gray-500">
                        {appointment.timeslot ? `${appointment.timeslot.start_time} - ${appointment.timeslot.end_time}` : 'N/A'}
                      </div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div>
                      <div className="font-medium">{appointment.citizen?.full_name || 'N/A'}</div>
                      <div className="text-sm text-gray-500">{appointment.citizen?.nic_no || 'N/A'}</div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div>
                      <div className="font-medium">{appointment.service?.title || 'N/A'}</div>
                      <div className="text-sm text-gray-500">Service #{appointment.service?.service_id || 'N/A'}</div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <div>
                      <div className="font-medium">{appointment.officer?.full_name || 'Unassigned'}</div>
                      <div className="text-sm text-gray-500">{appointment.officer?.user_id ? `ID: ${appointment.officer.user_id}` : ''}</div>
                    </div>
                  </TableCell>
                  <TableCell>
                    <Badge className={`${getStatusColor(appointment.status)} text-white`}>
                      {appointment.status}
                    </Badge>
                  </TableCell>
                  <TableCell>
                    <Button
                      variant="outline"
                      size="sm"
                      onClick={() => handleAppointmentClick(appointment)}
                    >
                      View Details
                    </Button>
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
          {filteredAppointments.length === 0 && (
            <div className="text-center py-8 text-gray-500">
              No appointments found
            </div>
          )}
        </CardContent>
      </Card>

      {/* Appointment Detail Dialog */}
      <Dialog open={isDetailDialogOpen} onOpenChange={setIsDetailDialogOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Appointment Details</DialogTitle>
            <DialogDescription>
              View and manage appointment information
            </DialogDescription>
          </DialogHeader>
          {selectedAppointment && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h4 className="font-medium">Citizen Information</h4>
                  <div className="text-sm space-y-1">
                    <p><strong>Name:</strong> {selectedAppointment.citizen?.full_name || 'N/A'}</p>
                    <p><strong>NIC:</strong> {selectedAppointment.citizen?.nic_no || 'N/A'}</p>
                    <p><strong>Phone:</strong> {selectedAppointment.citizen?.phone_no || 'N/A'}</p>
                    <p><strong>Email:</strong> {selectedAppointment.citizen?.email || 'N/A'}</p>
                  </div>
                </div>
                <div>
                  <h4 className="font-medium">Service Information</h4>
                  <div className="text-sm space-y-1">
                    <p><strong>Service:</strong> {selectedAppointment.service?.title || 'N/A'}</p>
                    <p><strong>Description:</strong> {selectedAppointment.service?.description || 'N/A'}</p>
                    <p><strong>Service ID:</strong> {selectedAppointment.service?.service_id || 'N/A'}</p>
                  </div>
                </div>
              </div>
              
              <Separator />
              
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <h4 className="font-medium">Appointment Details</h4>
                  <div className="text-sm space-y-1">
                    <p><strong>Date:</strong> {format(new Date(), 'MMMM dd, yyyy')}</p>
                    <p><strong>Time:</strong> {selectedAppointment.timeslot ? `${selectedAppointment.timeslot.start_time} - ${selectedAppointment.timeslot.end_time}` : 'N/A'}</p>
                    <p><strong>Status:</strong> 
                      <Badge className={`ml-2 ${getStatusColor(selectedAppointment.status)} text-white`}>
                        {selectedAppointment.status}
                      </Badge>
                    </p>
                  </div>
                </div>
                <div>
                  <h4 className="font-medium">Officer Assignment</h4>
                  <div className="text-sm space-y-1">
                    <p><strong>Officer:</strong> {selectedAppointment.officer?.full_name || 'Unassigned'}</p>
                    <p><strong>User ID:</strong> {selectedAppointment.officer?.user_id || 'N/A'}</p>
                    <p><strong>Role:</strong> {selectedAppointment.officer?.role || 'N/A'}</p>
                  </div>
                </div>
              </div>
            </div>
          )}
          <DialogFooter className="flex gap-2">
            {selectedAppointment && selectedAppointment.status === 'Pending' && (
              <>
                <Button
                  variant="outline"
                  onClick={() => handleStatusUpdate(selectedAppointment.appointment_id, 'Confirmed')}
                >
                  Confirm
                </Button>
                <Button
                  variant="destructive"
                  onClick={() => handleStatusUpdate(selectedAppointment.appointment_id, 'Cancelled')}
                >
                  Cancel
                </Button>
              </>
            )}
            {selectedAppointment && selectedAppointment.status === 'Confirmed' && (
              <>
                <Button
                  onClick={() => handleStatusUpdate(selectedAppointment.appointment_id, 'Completed')}
                >
                  Mark Complete
                </Button>
                <Button
                  variant="destructive"
                  onClick={() => handleStatusUpdate(selectedAppointment.appointment_id, 'Cancelled')}
                >
                  Cancel
                </Button>
              </>
            )}
            <Button variant="outline" onClick={() => setIsDetailDialogOpen(false)}>
              Close
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
