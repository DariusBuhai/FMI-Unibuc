import {Component, Input, OnInit} from '@angular/core';
import {Teacher} from "../../interfaces/teacher";

@Component({
  selector: 'app-teachers-list',
  templateUrl: './teachers-list.component.html',
  styleUrls: ['./teachers-list.component.scss']
})
export class TeachersListComponent implements OnInit {
  @Input() teachers:Teacher[]=[];
  @Input() groupFilter:string | null=null;
  constructor() { }

  ngOnInit(): void {
  }

}
