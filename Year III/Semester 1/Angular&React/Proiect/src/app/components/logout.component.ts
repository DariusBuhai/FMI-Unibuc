import {Component, OnInit} from '@angular/core';
import {AuthService} from "../services/auth.service";
import {Router} from "@angular/router";

@Component({
    template: ''
})
export class LogoutComponent implements OnInit {

    constructor(private authService: AuthService, private router: Router) {}

    ngOnInit(): void {
        this.authService.signOut().then(()=>{
            this.router.navigate(["/login"])
        });
    }

}
