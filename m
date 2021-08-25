Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D23F6C74
	for <lists+live-patching@lfdr.de>; Wed, 25 Aug 2021 02:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbhHYAJe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 20:09:34 -0400
Received: from esa16.fujitsucc.c3s2.iphmx.com ([216.71.158.33]:27576 "EHLO
        esa16.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235388AbhHYAJd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 20:09:33 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 20:09:32 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1629850129; x=1661386129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IaZq/mVsjwWtv0XkFPBO9ZZKlUhZWHBskSs69xPsRnY=;
  b=uGaqYLMbwSOOUkK07WB8MJluBNvohNYgTxR/A1OvMcavXeLX2LhPVWt7
   zW5BH0zS3PF5PsVeyDvwhFVWS681XWmfLFN/FCC4+qkncZJeG7gxyZyzJ
   6+alwxo3Gke54EKyxte1RdYWNb/ozfjHLgQBQ+KRGXHopHMQgiu2AIXC4
   oveJK42+RKVZgvaNNE/Zg3uMRkRAdVLAME0EfxFd1TbyAyRC9g3tdjkQk
   dchO4dKTHxp7rQVs0c3sSy8GdM6vt2sjL9EK7I3wT9xPGu9zwBjwJLmKr
   9i+U0qpJib+SLpkB73ReZXt7TbOsKyZgF+RhHgBzqyi9WSg6fLXQG4B9h
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="37629090"
X-IronPort-AV: E=Sophos;i="5.84,348,1620658800"; 
   d="scan'208";a="37629090"
Received: from mail-os2jpn01lp2055.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.55])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2021 09:01:20 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fdglCKYyZBXBqps9OzW9elXz7P0tZ/zIY1xa+gndjqMTCqLtATKq+7Uohnu+jy5x/FGB2o3/xWUI/k6h3k+DIEW8upk4AVnrRka501xVrerNbsUdAvqlPNw2m888py/QCtT0fuOxnkgApQfultQvXmcxV35NWCwIM1H85ZMrZNTaJMUdB/grOtfvU/04vMqHLV2tZJniG/3SjVwixxG629LXYksNYG/BwmJ2myEMEidmkeAtqOmZkecwVFk2dgH++YDRj++iYgTaLeUa+Rjd6g0Wt2sslCVr128f/3mRp8v/kEZePe5yXGE1gseSJ5/4uk5wkGX7U/NonuUi4+mipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/NgoPTXm5Hb9++7/11h93nf63eMPbp0a3zwBifbx3g=;
 b=NpD8QlxrTr7ycf+ItxWRE7d1vnaCmBGXoJvirF3GjE34T5moBU38EtRRXjARw8eBPAuhSPz1robjl0Z6h2fCHxs0FtPodYbjC0FNJxOrJOUF5LeVNNrTSz+fRN5b1T5hHQP56Agy8Ej5Px8lEf9l3bLBtCMl0cNMxV5kiX6GDzC3Eve3DYSzAJjSh3YzqiWQr1049WnnthYucEv3bxKPs+GPZ82NdzpWfEHzFWN3aVq5Q+lNiR+G6McSYWNo2cmloO5gKDHnaPrX4NXe1u6mt34J5y6/TUrNSS/RSm05ePR4472m1CLLSnHjqYebnwk2MTwvn0ij8RFUi4yeXCL2zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y/NgoPTXm5Hb9++7/11h93nf63eMPbp0a3zwBifbx3g=;
 b=i0Sp4NxFqo3IoM1J7DJJu4sTumrtRc7Mys52LWDU7+LeciXLAyeijQeVREKHxJKgcbVOzXlnLfrneO86J//Bq/pHoeNhuHEEMPqfXu2dFAMOFGbqZknrJ+ZcqHhxuJ0/l0qI5+YGwzsfJU+7Wsz3HEmPO7AYte7QMeCUFbHBOoY=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYAPR01MB4718.jpnprd01.prod.outlook.com (2603:1096:404:12c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 00:01:17 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::d0f9:bb55:deb4:88bf]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::d0f9:bb55:deb4:88bf%5]) with mapi id 15.20.4436.025; Wed, 25 Aug 2021
 00:01:17 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "'Madhavan T. Venkataraman'" <madvenka@linux.microsoft.com>
CC:     "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "pasha.tatashin@soleen.com" <pasha.tatashin@soleen.com>,
        "jthierry@redhat.com" <jthierry@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH v8 3/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Thread-Topic: [RFC PATCH v8 3/4] arm64: Introduce stack trace reliability
 checks in the unwinder
Thread-Index: AQHXj60kVJNMm5FzxU6EDROYO/rEjquAuwsQgAHqSACAAMNBkA==
Date:   Wed, 25 Aug 2021 00:01:16 +0000
Message-ID: <TY2PR01MB5257492F3B6B2E904AF5E46285C69@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-4-madvenka@linux.microsoft.com>
 <TY2PR01MB5257EA835C6F28ABF457EB0B85C59@TY2PR01MB5257.jpnprd01.prod.outlook.com>
 <62d8969d-8ba1-4554-16b4-1c0bd4f8d9e7@linux.microsoft.com>
In-Reply-To: <62d8969d-8ba1-4554-16b4-1c0bd4f8d9e7@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckermailid: 919e81a8178d48a1a67d7e32ee3d5163
x-securitypolicycheck: OK by SHieldMailChecker v2.6.3
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-08-24T23:58:43Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=0f27c542-3268-48e8-b71c-69fdb8c504c2;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 292f493e-fafa-4201-0843-08d9675b7623
x-ms-traffictypediagnostic: TYAPR01MB4718:
x-microsoft-antispam-prvs: <TYAPR01MB471836C385E62A3E3BB81FA885C69@TYAPR01MB4718.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6/DuXXdftpoTCetUxjRVB1gztF0n6v5UXyd9AdXM87s7tNRcsHwiOCcBZAdrH7Mwuxil2isCoKd0DtzwGJEH9bt+Fo8j0P6QAZ51r5Im1HLdCnVTn90S+myyBNS7epM0Wouy6o3DRhD83ZdPjA4aA1lBxI2Kq39/uT6WBE72FFqZlYb6B+iRMr0Bk1mGoMfMtLcqiBjr1kJK5IGt2cQTBnx9FB3ATcAV1lOZa1RKBMb7P19mQxYNlhFzIL++70vSBfG2cwwhB+LPIQ/vBecZQ7kjCCGkfJc/D7JaBidjNVJtbbPQrmMML+ntpq5EwaGsmUYLAtcMP49qPVMIllPUkSpyB2kXmVVRhu6rKqpsyDU2G6nfPWWTZmZLQLTlTQTmdwCwCUH94crm2L9azqQZi68zvc0weP7h179IK+v73S1NEg+od32dgV4C+GJzwbjOm2qe2XmI15eRGzxM28HKqq1MJ6W44d0aUlRboG8Zx+TZQWd6jZlQzZ1QzpEu2gNr9iUMOtPePHfZ8HHz65zlVTa1ItM2fsjNjZWCwv0oY9KEW9AzN52bR7ThdFhsNdY9zrFehZIHVHP04/6rqHkHcyum/QErj4oiEjQMPsTra6Pagl/oIrPRDClTNtZcf+XnwqTXhyldcYBMvkvLVADtyQ+Gj5nAm//hgm93lRuzFEYKPURzGbrU3kF6v+PXvU0VC43HvFL+EX0LYchFFofR4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(136003)(366004)(6916009)(4326008)(54906003)(33656002)(38100700002)(186003)(26005)(122000001)(7416002)(55016002)(7696005)(86362001)(478600001)(85182001)(6506007)(64756008)(76116006)(9686003)(2906002)(66946007)(52536014)(66476007)(8676002)(66446008)(66556008)(8936002)(5660300002)(71200400001)(316002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?dGRpdEZBZFNTSEZsVGZLM1QvNDdIM0lGTzdLbG9hY3gzeGc2SldKRVp0?=
 =?iso-2022-jp?B?ZVQ1MVljdHUxTmVybldIWkpsayt2Wi8rN0Z4S1o0SlVEejM0dnptZXIr?=
 =?iso-2022-jp?B?eS8zbmtTM2RYUUdydzkzTmQwL25TNWlBeWZsQUVZYTZQYVVnRE0rODhi?=
 =?iso-2022-jp?B?UHJRak8zZUdXSVFKSWd5T2NZS1NYQUlGTDh4b3djMWJNUjAyR3ZrWlli?=
 =?iso-2022-jp?B?cGVUUjhTR3hCdHJrWjI5K2EwNE8xZnljWEg3Nk9CbzJFUHlKRG1YOWd4?=
 =?iso-2022-jp?B?TlF5QU9IcTN1a3BlMUZzMzBMdjBUSnlieG1NUWlzTENHN2xwY0hQSWgv?=
 =?iso-2022-jp?B?ZzNPcnhjWVMvMVRnL2hKNmRZWThnQ1dxZ0RWOVdpUEFHeGU0d3ByY0E3?=
 =?iso-2022-jp?B?MlZHam1DOE5jYjliQUtjZjZCTGE5S0ZPMGxxTklhWWN5a1ZzSUV3Q2d2?=
 =?iso-2022-jp?B?TGFvcG1uZWZxK25OeFFFMkQ1OHpUZDllT2w0cHgrZm1QR3pPL3Iva2J6?=
 =?iso-2022-jp?B?OUlvSUdOQnkxVit5S0pjSzhjeWlkaXBUejZXd2JGck1EVlRGbUpSendS?=
 =?iso-2022-jp?B?SjBjdEhMOTZuRnJkSUFNL1lucWVYYkdDTzZiYVJoOWdyZWVvR05VTU5T?=
 =?iso-2022-jp?B?MGtUS2hBZEU3N0k2eGNsMW9BQyt2SExIV3BwSk9RdDM5NlZ5MHM0MEU2?=
 =?iso-2022-jp?B?ak9xb0xaVzVUbmxNM3pKcllKeCtZdUppMEVsMExwbkdrMXZJYnZvOHVq?=
 =?iso-2022-jp?B?QzdNdHl6Q1pKbTZlTmN3YzQ1UUNSM2lCU1dtbjZHZXYrSGFJWGwrYitK?=
 =?iso-2022-jp?B?bkQ3bnorVlV2OEpxMU9KVWh5K0h1cTRQK0dnd0JnN2dwNnRFMCtid2VO?=
 =?iso-2022-jp?B?VGJTT2gvK0hBdnZoRlVkd1VoUXB5WjVOcUxRZ2JLQXg5RlpBZU1VWVI3?=
 =?iso-2022-jp?B?dUMzSEhqU2M1Zkk4SC9SOXdkSFdNODY1YUNUMmRZQit3WlZKR2tOaDh3?=
 =?iso-2022-jp?B?dlNmZ051YU9iQ1dqZWk3L29FZW1GOWcrdlgvTVZ2ZVFuRnZYWVNONmZF?=
 =?iso-2022-jp?B?SUxvSG10MTVlTCtVNEo2VGFzc2R5aXVqME9vTVQwZGcxNUtEem5oK1dK?=
 =?iso-2022-jp?B?RFZCYjdtcjlWQmF6WUJJUGpnd1RVaDl1aWhBUEFGMzg3Qm9ub2lBZGt1?=
 =?iso-2022-jp?B?RVpKdVpWRWZldGI5eStEd25GR1h6K2E5YWRjdWJmZDluK3gxc0o4Tkoy?=
 =?iso-2022-jp?B?N3M2cFNYdXhYNlI2RG9yTzBQSldaZnZvQTh0VWwzWGYvT3JxWndMRXVz?=
 =?iso-2022-jp?B?OHR0bGwzQVAyOTBPUnVkZG9UYVp0c0pPZDlnTTA0aTBSWnpjU0l0NDJr?=
 =?iso-2022-jp?B?N2E0RHQ3a1ZndlVBUkNOeGNmMkFTbDF0czZ4Njk4UEhDMU9qZW4zOXRz?=
 =?iso-2022-jp?B?M05OWTlmbUpQZjRRbkl5V0J3NytKWGdyTEpua3ltbVYxd1psRmtlSStU?=
 =?iso-2022-jp?B?ZXRURGU2Qmg1ZWs3bGUrdW9HVzMyM281R0N1MnVTeUdVQldzQllQc2Vw?=
 =?iso-2022-jp?B?dEhWdlZEU1Y5YnNqMjRuTXRCY01XVjFybHhFaHBOY2pmVFdxcjlJZjE1?=
 =?iso-2022-jp?B?VS9EK0hIam1sdTNNNDhIL3dtSnZnT1ROZ0xxVlRvU3NoNjdHNTVkSElw?=
 =?iso-2022-jp?B?cmdkRFVxbWVTUTV6NWFIbVovdXVwK0RiMzQ3V1pLWVJOdkxRRDdjVzVm?=
 =?iso-2022-jp?B?U2I5ekhodUZZVmhqSGtza25ydUJEdGhKYVVxbHl5Ym01cDNQY0Q0RWNX?=
 =?iso-2022-jp?B?Z1owTU56QTlYNjlrWFZJMU1kZG9iRERUVmZQRDZWc2hsWFV3RDkveFBK?=
 =?iso-2022-jp?B?S0VpeEpwSHJyQTJUc3A1VHpzVWx4WHZ0b1RkY2ZpQnZ3enpia3EyK3BN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292f493e-fafa-4201-0843-08d9675b7623
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2021 00:01:17.0508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1yZ3TdVokMWnKwrItSFmW2vQ1wzvtCsnkl0/TMl/I1q4AjkkhFz9xGVgVhJ/LNDR4niKdKVwjuMqZqvw/mtqJnY6Va45pClGRzZgSSR7ZgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4718
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > Hi Madhavan,
> >
> >> @@ -245,7 +271,36 @@ noinline notrace void arch_stack_walk(stack_trace=
_consume_fn consume_entry,
> >>  		fp =3D thread_saved_fp(task);
> >>  		pc =3D thread_saved_pc(task);
> >>  	}
> >> -	unwind(consume_entry, cookie, task, fp, pc);
> >> +	unwind(consume_entry, cookie, task, fp, pc, false); }
> >> +
> >> +/*
> >> + * arch_stack_walk_reliable() may not be used for livepatch until
> >> +all of
> >> + * the reliability checks are in place in unwind_consume(). However,
> >> + * debug and test code can choose to use it even if all the checks
> >> +are not
> >> + * in place.
> >> + */
> >
> > I'm glad to see the long-awaited function :)
> >
> > Does the above comment mean that this comment will be removed by
> > another patch series that about live patch enablement, instead of [PATC=
H 4/4]?
> >
> > It seems to take time... But I start thinking about test code.
> >
>=20
> Yes. This comment will be removed when livepatch will be enabled eventual=
ly.
> So, AFAICT, there are 4 pieces that are needed:
>=20
> - Reliable stack trace in the kernel. I am trying to address that with my=
 patch
>   series.
>=20
> - Mark Rutland's work for making patching safe on ARM64.
>=20
> - Objtool (or alternative method) for stack validation.
>=20
> - Suraj Jitindar Singh's patch for miscellaneous things needed to enable =
live patch.
>=20
> Once all of these pieces are in place, livepatch can be enabled.
>=20
> That said, arch_stack_walk_reliable() can be used for test and debug purp=
oses anytime once this patch series gets accepted.
>=20
> Thanks.
>=20
> Madhavan


Thank you for the information.

Keiya
