Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12DD4AD283
	for <lists+live-patching@lfdr.de>; Tue,  8 Feb 2022 08:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbiBHHur (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Feb 2022 02:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348591AbiBHHup (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Feb 2022 02:50:45 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120071.outbound.protection.outlook.com [40.107.12.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17626C0401F1;
        Mon,  7 Feb 2022 23:50:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7cIAXGBdzInghUiACaBL4qEwNXC636YQl55cKDJlhEMhe7PaogQxZRBqujfSM4aad9sBhftKfLGVoLY9qp30idGPRcQ8vsFbfr3nW69W3/4orf5Aagrx+Scu9UxPxfpzbAbN+WsfEAktRVoEfeLWAR65xCu+0+6NPKmxq7++S6zuV2zAAqAZNOAJnNhaNxaYyxbKLpuyi3GQsF1lqKuroSrTtHjHzCfcR5hBQ7q7Kau+1kbyWpDMgfRNZ5GQW8UBhSaPkkGRdEmCzQuaDpY8SmbMWQo7rh0c++z48PgtBnoWAm9nujjVMytULBOdjDXMVaPL1rH3kj/paIdllUc6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j1gS0rB0hc6ESrQKm3wYJ7iNhtPCdcyxUFc/uJ6DJos=;
 b=hYv1SXJKdjukHvgqWSPx1N/yfr0vaqZvjhtwt+NyWakJdZ4w5yMRhkXjxCGiNsge5iVvsniUFsKBsgBHCznvjpdVIPd9DX7ud5JfUyE6twwjn+a6HZQfPtBESY0MEobYK0blF81SOUS1pC/4VYkoWV1gy4OCNsXKZdb/CJ3B8PvdlUY1F/bu3VpyYq+Zc6oIO6JxHCLdTfkFSulK7StZSOGbTBj9v7SsXeXM1xZDZ1uL81Q/2TSbi3R2yfWAqyBIpc4Y1eZxVTHg8dPFmk72YrJ0bbTyEel0u6U9Tb/z6Ac7QmEWOmDgMEmybneatkd9gu2tdIk4quViYkXJIGnaYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB4100.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:42::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 07:50:40 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 07:50:40 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>
CC:     Aaron Tomlin <atomlin@atomlin.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Michal Suchanek <msuchanek@suse.de>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>
Subject: RE: [RFC PATCH v4 00/13] module: core code clean up
Thread-Topic: [RFC PATCH v4 00/13] module: core code clean up
Thread-Index: AQHYGJPj0SgwpYxqsU+2qmwMGXXo0qyCHvGAgAY0jICAAAiMAIAADFwAgAEpf7A=
Date:   Tue, 8 Feb 2022 07:50:40 +0000
Message-ID: <MRZP264MB2988F32D78CC49C4C9E486CBED2D9@MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <1ae3a950-8c1e-a212-e557-8f112a16457d@csgroup.eu>
 <20220207164659.ap42at2nphxu4q6o@ava.usersys.com>
 <b0a54f00-b9ac-df55-e8d2-d3eb95039a95@csgroup.eu>
 <20220207180148.bbstggd4yr5ozfrf@ava.usersys.com>
In-Reply-To: <20220207180148.bbstggd4yr5ozfrf@ava.usersys.com>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f1dbb0f8-9c17-46ef-930f-08d9ead7b3a2
x-ms-traffictypediagnostic: MR1P264MB4100:EE_
x-microsoft-antispam-prvs: <MR1P264MB4100240F2F33BB7D1F9D06ACED2D9@MR1P264MB4100.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: huLFQFbcReHR1+JV+CKOutMRaMmjPfpGopBklqBXKNs44+e6DcNryYA+mvxiRFC53Z71zwcD2OG/bUpGI2x1zdRR/rOSCKYp5L5DNTJaaMwELsZj+6xrK/3uewN1Ysz3spWFIxwDrp3sqNzucLnF/VM15WKsOtCkOPUVuNmoGtCdJOcY9ys7wkXcCc+R+H14oilXXss7Plt64kXEn7eTUT/6dq7HmeqR0/epNG048nXCEc+oSKXXi3bfipsG+A9FT7X9GoLuZllPDiyZ3RmjXAimfB8ra9BCyIMR3qciOcnUBt8b/fb+3z4d2KU6hwh+GzGmarQ2OuN/3Gc0AjXxqF6TYXnbMcpEvxoqslptmZZlWCx2Y1+qSnMpJ4OFuknWU6yWjJ3JeeO1f3y2GIQBK0qVkQJ2eu4ztTn3w5n1Fd7UOY5KZ4zlr0T034GSIFJhUIuADPVYZtXds3hQCUwINejiGpGxlx0Dv+A3BdrfybERPT6r3l20vjVWEkKdZYTbjb43XhJ589Zrl6BuqACYi3xlDcFGvg2/PkusbH2p6uofwWzABfqAsEpBe7ipAwu9vyBKlhGU029kmfMcNpUaP51aiffaXgUMaRoUmDYRwOSQ6W9e1JlsGOnkvrVqQxPqy2ylearXK9nF5+lYdgoaJ92aMhGt+oyhCVPdmOjn1rlk5tBRCY7naZmvClTk/baTTePhSFpnpAmA1SA8S5y7qsopvinJWrvmHTtVEek8KKr0TqmiDX7kc4g2q4ECMMHZAV17VVn8fWo9R7QgHNtbe+1C/qwR2TrR6sn2A8VPTGo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52536014)(54906003)(86362001)(6916009)(33656002)(508600001)(76116006)(6506007)(7696005)(44832011)(9686003)(71200400001)(8936002)(66556008)(4326008)(66946007)(66446008)(64756008)(8676002)(66476007)(83380400001)(966005)(316002)(186003)(122000001)(38100700002)(38070700005)(7416002)(5660300002)(55016003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3VORTRoYlM5SWxPV2Qxeml5WVAzak5DQzJTOC80c1R0RDZkUzhkb1ZZU3Mz?=
 =?utf-8?B?TmJUVS8vaTQvNVhiZ25HMjN3d0ZiSTNQYmlMOXFsUkFoUDVLa2tCZGpKU3dG?=
 =?utf-8?B?aDdYTHJMb3N2bkkybUMvbGFDa3lNVGVKdXozTnhVRGlZZ0E2aUtwa09Wa1kx?=
 =?utf-8?B?NllnL1JDekMxWitkQnFpcHhpWDM4Qy9WeGRtQnE1YkUvd2NEbGRnMUgxQVZO?=
 =?utf-8?B?VUt4ck1nQW9ubGtyYkxVcXZFSU9tWDVLckhybVNCWElZUWkzNmZ6REJyWHZi?=
 =?utf-8?B?aGVDYXlKbE13MW85N1I1UmlTRm1xTnNNUll1UERDb3dSTW1FUGVZcVdlZWZm?=
 =?utf-8?B?c00ycUI0RFFiUWJWOW9SdGtoL1ZsbjVyN1RPeThhSjlDaGswT2N3Y3RBSDkr?=
 =?utf-8?B?TmZKeWJFNUgzQjVhT1VrbkxqV0pDa2dnTFQzdGVPVlIwL0dhK29aMmxXbDYv?=
 =?utf-8?B?VWhvbWRvcitMT0MraTBlc1U4Z0NUYUFwWkl5elk3ZU1xT2Q0bzNyOVR4NDZJ?=
 =?utf-8?B?WHFIekFSeDAybUU0Rm1vY3MvdmQrdVZkQTVpa2tvOTUxOXZHais4MnRvQ2gz?=
 =?utf-8?B?TmoxQlEvdHdRa2w5Z2dXY2RyMU1uaVNzd2JiRFdsOVVYSkZqMCtVQU1BOEtz?=
 =?utf-8?B?NmVpcC9kaVFMK0pDSmhHbi84ZkJpNTJ3dmxMS0FYRHNHaExoMUhOQ1dBdVIv?=
 =?utf-8?B?K09hRk9USmhPZUJqci91bnJGUU1XU0NpdE9pL1NLckY1dk0zSFlCWlg5TUtN?=
 =?utf-8?B?c1ZMTGxBdjUvbHVicGgvNGxPMlhIK0Z5S2I3Z3NoaUlzZk5FdWpLNDQrQjJl?=
 =?utf-8?B?Rnd0Q2Q1c1hlOWhMZnVZSVQrTXUyL0gxS3FrNGZrOVNRN3MzYVpCSFZ5QkJi?=
 =?utf-8?B?Zmk4clpocFVHUG9RZmYydlhBTVR6Ykh6OHZZMUdPSGxBMmFYVkNwTnRWUk5P?=
 =?utf-8?B?b3dtUEFvWXpkRXRXU3RoTEE1TXhkeVdwTkIwalFoMkRsSzYralNUR2k1VDRE?=
 =?utf-8?B?U3M2OEpaTGltdVBJd3dVeVQyQmFQd0dzcDVXMlhRTXE1d21pM0NzTnAyUXNn?=
 =?utf-8?B?M2xtMXFyRFgvcjZDN1RsYVhpeXVTKzl3M3lIMDJZQk0yOGVxcWtOOTliKzR6?=
 =?utf-8?B?eXJqKys1NEZDREJnT3NRS2N2ZjZZQkg5UXEweS9nM01jS21hMHVHbFZIMGtQ?=
 =?utf-8?B?TGh3eURZNVpkWGtmSjQrZ2U3S1A1ZmRWN0dORmtja1U5K0NrcXgzU3VEbTZn?=
 =?utf-8?B?Z1NtOWI2STBnN20wWDF6Ukw1NzN4Nm45MjBVU3NPTzNHdXgvVXdkTXp1RnV5?=
 =?utf-8?B?dFhSdHg1WmQ3c2ExdVNFcVFJOEROZ2p2MkFlUHhvNEcyVFlTbG5XMUJIZGJF?=
 =?utf-8?B?L1UrNWhpcTRyMDRBNDRuMC9nYXE5L1BlZFMzdk10djQ3ZTRITXhhNUw0TDhu?=
 =?utf-8?B?cU0wVzRwcWFKZUkrUjVGRFRnVlFZSzNidXVvbnZiWFl1bnFFMUgwbVVsNXdZ?=
 =?utf-8?B?SC96NlIzMEt1Q0liNlA4UzlwMU5VM25BWHFSWnZ2ZHJQcW40MGlCRTJMTW5E?=
 =?utf-8?B?TFkydHNzZUt5ZlhwZFZjKzUrMjZDVW91V1pIZ0tYWkIxc25naDg5cDc5dnVX?=
 =?utf-8?B?TEozSFZvUGd1SEVhV0VTRWI1RXBkQVhXNXRWclVjd05XUWg0UkFubnBqazdz?=
 =?utf-8?B?eFBaN3c2MFJHMmVLeGVWY1VNS1NCYlZGREVOYW1jQ3BJWVJBTTVhT0ZIdmpZ?=
 =?utf-8?B?NnV3eXlKdmlDWWJVUW9kejhJN3owS1EzdFgxR0F2Y1JGSW9DTjM3U0xxTjZh?=
 =?utf-8?B?NGduUHV5bFhDSm05OVhzV2xrZVBtVFBWaHhnYlJIdWRLWU94ZlhJN1NEUFBo?=
 =?utf-8?B?Mlg1eldxdlpORHRBOUEwZi9KcGpML285ajRsYVNjL2J4dTdnMEVEaEY3OG1G?=
 =?utf-8?B?WFpJVWlRRnhReWdkTVpqakFpTzZJSDVEKzU4NmoxeUtGUzB3ODAxYkY3blM5?=
 =?utf-8?B?Qm1PdG1KVWtpZ3VJUisyWDJJUnNyVWdpa1l5amtZVDNDdS9sbU9WeGdaKyty?=
 =?utf-8?B?QUQ3UXlrd2hNV21ONUtaQ3FZcXhiZ2JKUHBjSFZVVjRpMnhicFdGcmEyQnVw?=
 =?utf-8?B?djFhSFBDQlFrdmpqVGp2bkdGdEdZUXdVVnE1Wm9WRWxqZlJ1ZHVSbTZwV3J2?=
 =?utf-8?B?R1dvQTRTMGN4K1dVcEFTVzJTMjc3Nms1YWg3V1NTd2QxUnNBeWZtZzNSR2J4?=
 =?utf-8?B?ZmZSUHBMdVh0Sk94dmdmYVVmRzR3OXZNVVAxTGphdWZsUFFpMy9zNzZtc3Yz?=
 =?utf-8?B?QlRTQm1vM1hOVU8xb0tOc2xEK2REcVJEWjJMdVNjUDVNUVRVTDE0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f1dbb0f8-9c17-46ef-930f-08d9ead7b3a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 07:50:40.1655
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5u1Q//HpkbjmBxR0iZK2Vk4R8Z0p9H0jzK+AROuL5CczrLE3zzBb8JbsLSI8JL8ZMt556yMjhipdc+jFkXnHcmLtpBX1OI+NouJUkXo//4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB4100
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URI_HEX
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCj4gLS0tLS1NZXNzYWdlIGQnb3JpZ2luZS0tLS0tDQo+IERlwqA6IEFhcm9uIFRvbWxpbiA8
YXRvbWxpbkByZWRoYXQuY29tPg0KPiBFbnZvecOpwqA6IGx1bmRpIDcgZsOpdnJpZXIgMjAyMiAx
OTowMg0KPiDDgMKgOiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAu
ZXU+DQo+IENjwqA6IEFhcm9uIFRvbWxpbiA8YXRvbWxpbkBhdG9tbGluLmNvbT47IEx1aXMgQ2hh
bWJlcmxhaW4NCj4gPG1jZ3JvZkBrZXJuZWwub3JnPjsgTWljaGFsIFN1Y2hhbmVrIDxtc3VjaGFu
ZWtAc3VzZS5kZT47IGNsQGxpbnV4LmNvbTsNCj4gcG1sYWRla0BzdXNlLmNvbTsgbWJlbmVzQHN1
c2UuY3o7IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7DQo+IGpleXVAa2VybmVsLm9yZzsgbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW9kdWxlc0B2Z2VyLmtlcm5lbC5vcmc7
DQo+IGxpdmUtcGF0Y2hpbmdAdmdlci5rZXJuZWwub3JnOyBnaGFsYXRAcmVkaGF0LmNvbTsgYWxs
ZW4ubGttbEBnbWFpbC5jb207DQo+IHZvaWRAbWFuaWZhdWx0LmNvbTsgam9lQHBlcmNoZXMuY29t
DQo+IE9iamV0wqA6IFJlOiBbUkZDIFBBVENIIHY0IDAwLzEzXSBtb2R1bGU6IGNvcmUgY29kZSBj
bGVhbiB1cA0KPiANCj4gT24gTW9uIDIwMjItMDItMDcgMTc6MTcgKzAwMDAsIENocmlzdG9waGUg
TGVyb3kgd3JvdGU6DQo+ID4gWWVzIGFuZCB0aGF0J3MgdGhlIHB1cnBvc2Ugb2YgdGhlIHBhdGNo
IEkgcHJvcG9zZWQgYXQNCj4gPiBodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bGludXgtDQo+IG1vZHVsZXMvcGF0Y2gvMjAzMzQ4ODA1YzlhYzk4NTFkODkzOWQxNWNiOTgwMmVm
MDQ3YjVlMi4xNjQzOTE5NzU4LmdpDQo+IHQuY2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Lw0K
PiANCj4gSSBzZWUuDQo+IA0KPiA+IEFsbHRob3VnaCBJIG5lZWQgdG8gZmluZCBvdXQgd2hhdCdz
IHRoZSBwcm9ibGVtIHJlcG9ydGVkIGJ5IHRoZSByb2JvdC4NCj4gDQo+IEknbGwgaGF2ZSBhIGxv
b2sgdG9vLg0KPiANCj4gPiBBcyBzdWdnZXN0ZWQgYnkgTHVpcywgdGhpcyBmaXggc2hvdWxkIGdv
IG9uY2UgYWxsIG9uZ29pbmcgd29yayBpcyBkb25lLg0KPiA+IEJ1dCBpdCB3b3VsZCBiZSBuaWNl
IGlmIHlvdSBjb3VsZCBqdXN0IHJlbW92ZSBwYXRjaCA1IGZyb20geW91IHNlcmllcywNCj4gPiBv
dGhlcndpc2Ugd2Ugd291bGQgaGF2ZSB0byByZXZlcnQgaXQgbGF0ZXIuDQo+IA0KPiBQZXJoYXBz
IGl0IG1pZ2h0IGJlIGVhc2llciBpZiBJIGtlZXAgdGhlIHBhdGNoIHdpdGhpbiB0aGUgc2VyaWVz
OyBvbmNlDQo+IG1lcmdlZCBpbnRvIG1vZHVsZS1uZXh0LCBieSBMdWlzLCB5b3UgY2FuIHJlYmFz
ZSBhbmQgdGhlbiBhZGQgdGhlICJGaXhlczoiDQo+IHRhZyB0byByZXNvbHZlIHRoZSBpc3N1ZSwg
bm8/DQoNCkkgZG9uJ3QgdGhpbmsgaXQgaXMgZWFzaWVyLg0KDQpJZiB3ZSBkbyB0aGF0IGl0IG1l
YW5zIHdlJ2xsIG1vdmUgc29tZSBjb2RlIGZyb20gbWFpbi5jIHRvIGFyY2hfc3RyaWN0X3J3eC5j
IHdpdGggeW91ciBzZXJpZXMsIHRoZW4gbW92ZSBpdCBiYWNrIHRvIG1haW4uYyBhbmQgcmVtb3Zl
IGFyY2hfc3RyaWN0X3J3eC5jIHdoZW4gd2UgZG8gdGhlIGZpeC4gVGhhdCdzIG5vdCBnb29kIGZv
ciBoaXN0b3J5IHRyYWNraW5nIGJlY2F1c2UgdGhlIGNvZGUgd2UgbW92ZSBiYWNrIGFuZCBmb3J0
aCB3aWxsIGFwcGVhciBhcyBuZXcgY29kZSBpbiBtYWluLmMgd2hlcmVhcyBpdCdzIGNvZGUgdGhh
dCBoYXMgYmVlbiB0aGVyZSBmb3IgeWVhcnMuDQoNCkFzIHdlIGtub3cgdGhlIGNvZGUgd2lsbCBi
ZSBiYWNrIGluIG1haW4uYyBhdCB0aGUgZW5kLCBJIGxvb2tzIGVhc2llciB0byBtZSB0byBub3Qg
bW92ZSBpdCBhdCBhbGwgYnkgbm90IGFwcGx5aW5nIHlvdXIgcGF0Y2ggNS4NCg0KVGhhbmtzDQpD
aHJpc3RvcGhlDQo=
