!----------------------------------------------------------------------------------------------------------------------------------
! SPHERA (Smoothed Particle Hydrodynamics research software; mesh-less Computational Fluid Dynamics code).
! Copyright 2005-2015 (RSE SpA -formerly ERSE SpA, formerly CESI RICERCA, formerly CESI-; SPHERA has been authored for RSE SpA by 
!    Andrea Amicarelli, Antonio Di Monaco, Sauro Manenti, Elia Bon, Daria Gatti, Giordano Agate, Stefano Falappi, 
!    Barbara Flamini, Roberto Guandalini, David Zuccalà).
! Main numerical developments of SPHERA: 
!    Amicarelli et al. (2015,CAF), Amicarelli et al. (2013,IJNME), Manenti et al. (2012,JHE), Di Monaco et al. (2011,EACFM). 
! Email contact: andrea.amicarelli@rse-web.it

! This file is part of SPHERA.
! SPHERA is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
! SPHERA is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
! GNU General Public License for more details.
! You should have received a copy of the GNU General Public License
! along with SPHERA. If not, see <http://www.gnu.org/licenses/>.
!----------------------------------------------------------------------------------------------------------------------------------

!----------------------------------------------------------------------------------------------------------------------------------
! Program unit: ReadInputRestart                           
! Description:                        
!----------------------------------------------------------------------------------------------------------------------------------

subroutine ReadInputRestart(ainp,comment,nrighe,ier,ninp,nout)
!------------------------
! Modules
!------------------------ 
use Static_allocation_module                             
use Hybrid_allocation_module
!------------------------
! Declarations
!------------------------
implicit none
integer(4) :: nrighe,ier,ninp,nout
character(1) :: comment
character(80) :: ainp
logical :: restartOK
integer(4) :: ioerr
character(80) :: token
logical,external :: ReadCheck
character(80),external :: lcase, GetToken
!------------------------
! Explicit interfaces
!------------------------
!------------------------
! Allocations
!------------------------
!------------------------
! Initializations
!------------------------
!------------------------
! Statements
!------------------------
call ReadRiga(ainp,comment,nrighe,ioerr,ninp)
if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA",ninp,nout)) return
do while (TRIM(lcase(ainp))/="##### end restart #####")
   select case (TRIM(lcase(GetToken(ainp,1,ioerr))))
      case ("step")
         token = lcase(GetToken(ainp,2,ioerr))
         if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA STEP value",  &
            ninp,nout)) return
         read (token,*,iostat=ioerr) Domain%istart
         if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA STEP value",  &
            ninp,nout)) return
         if ((ncord>0).AND.(nout>0)) then
            write (nout,"(1x,a,i12)") "Restart from step: ",Domain%istart
            if (Domain%istart<0) write (nout,"(1x,a)") "Negative restart step!"
! Only the last read option keeps active 
            if (Domain%start>zero) then
               write (nout,"(1x,a,f20.12,a)") "Restart from time: ",           &
                  Domain%start," option ignored!"
               Domain%start = zero
            endif
         endif
      case ("time")
         token = lcase(GetToken(ainp,2,ioerr))
         if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA TIME value",  &
            ninp,nout)) return
         read (token,*,iostat=ioerr) Domain%start
         if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA TIME value",  &
            ninp,nout)) return
         if ((ncord>0).and.(nout>0)) then
            write (nout,"(1x,a,f20.12)") "Restart from time: ",Domain%start
            if (Domain%start<zero) write (nout,"(1x,a)")                       &
               "Negative restart time!"
! Only the last read option keeps active
            if (Domain%istart>0) then
               write (nout,"(1x,a,i12,a)") "Restart from step: ",Domain%istart,&
                  " option ignored!"
               Domain%istart = 0 
            endif
         endif
      case default
         Domain%file = ainp
         if ((ncord>0).and.(nout>0)) then
            inquire(file=Domain%file,exist=restartOK)
            if (restartOK) then
               write (nout,"(1x,3a)") "Restart file: ",trim(Domain%file)
               else
                  write (nout,"(1x,3a)") "Restart file: ",trim(Domain%file),   &
                     " not found!"
            endif
         endif
   end select
   call ReadRiga(ainp,comment,nrighe,ioerr,ninp)
   if (.NOT.ReadCheck (ioerr,ier,nrighe,ainp,"RESTART DATA",ninp,nout)) return
enddo
!------------------------
! Deallocations
!------------------------
return
end subroutine ReadInputRestart

