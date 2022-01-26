Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12FDA49C754
	for <lists+live-patching@lfdr.de>; Wed, 26 Jan 2022 11:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239822AbiAZKUZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jan 2022 05:20:25 -0500
Received: from esa1.fujitsucc.c3s2.iphmx.com ([68.232.152.245]:13903 "EHLO
        esa1.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239821AbiAZKUY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jan 2022 05:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1643192424; x=1674728424;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=915HicqR6d54ix1BMaKWt8kQIXfiQGDgInlM+MACqTQ=;
  b=hEvnWBmjEdPa44TBCCVRnl7r9b2XGa8WRGyvZFALtibGqUiHradBNTA6
   VLU0hGjWHBsB0njxGXqgFKV4r/JTkUtZTsnospfkSwGZsX0Uj1pLUYSe7
   hYSD3tPcMO6s2xHK/Y+upyGLFvm9LA0BCRGrb1O6UNOG26W/JkW/nHz1y
   kWesH2uXLIxj9Z+gSvCn0WQ+SDs2D2WIsHUB90Vx2VS9mpMdBsZRLOUS3
   4llbjl/q8GFKwHUPpq0DksCnAodirlbC42+g3g65gxNvPYZx3j/uL3N4i
   a6owRlGOto2QeppLf4BafpvCi8puCGK2cz6KulZIYtNKwuzLyY8YpWjWE
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="56637206"
X-IronPort-AV: E=Sophos;i="5.88,317,1635174000"; 
   d="scan'208";a="56637206"
Received: from mail-os0jpn01lp2108.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.108])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 19:20:19 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dy64lCF26CNIBARNui4qRqTBRszI7csf07A+K23l7+nxK6EeAer+yfREW12vi52IjsmLeBi4jC6wATYAB62Aa50tnvJOJfxfGgCdAOxLc80ZcGhOgY8Qk++npUbek588ifkINUnmfAGGgu0PhP07NO4HdnlMNRL2tzutRzvXPBzfVIiLhon9oPOr03YlBrcimjGWz1UBxPpLanboxd0nB292l6ZTMQTIj8IE2eRdykxENyt+kXIqhGWVtoxiKNcs3G2+0+TZLYrzvXOY3JZRuMSpZhlCg6LzjiNhWpBBjSVXjLIBw039sFgrm7g8Ew9WedlrOVd5SY0HTyoAJ27Rpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkESjUB1mf6Ee7rZyPTlAU+KqrMvd66q5pQDQlkFIiU=;
 b=KIflbfIljP3dhsgn+qrQ4IdJ6U7NAyS0CP10sbEyN/EqE7VDRWtHkFPyS7fZ4NmcyUTRYzsveks66ICS6xZd9gwcnM3xFJ5UydXhd0awV4UUPQdW+cYBko+fRwtLX8iLsPd0eCItE4LtBjguT1yT+oichJBr/ybUF1yX0rXwzIy7CHDezvRny3O9/bzpDQbHFQwgX5N+aNevVz+QbHctguFbyXAXQkBOIdxp+lNJbvMXK2rwHiXWYsygpzgTJDaOFzuYI1ZxYZuhESb5IW85ogIM8zXJw2tcVNskN5/clKwUv6t6o6DA3ZWgZUm1miC5KHB2cUPi8eOH6gzpt+IYTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkESjUB1mf6Ee7rZyPTlAU+KqrMvd66q5pQDQlkFIiU=;
 b=gGj4ydaD4BJbo3HK1jjsz+jlBSdv5Z1dBneEP3Qwl7MTv7zfBc+UxUjnnt9st1ZdGML8JM+yrcZQmCgu1d+GhNZa55nAbbHRIsaWnT9RwfBYoUfDlzUAouFJMwSE0Lvd1kc6t2neQKBTRFCZOydDg4bCnbTr/98JK3wB51kIRB0=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYCPR01MB8390.jpnprd01.prod.outlook.com (2603:1096:400:152::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Wed, 26 Jan
 2022 10:20:17 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207%4]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 10:20:17 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "'Madhavan T. Venkataraman'" <madvenka@linux.microsoft.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Thread-Topic: [PATCH v13 11/11] arm64: Select HAVE_RELIABLE_STACKTRACE
Thread-Index: AQHYC7J0j/1dz1/1vkuQ8Ct1CeQ76axzKz3QgACgioCAAPRucA==
Date:   Wed, 26 Jan 2022 10:20:16 +0000
Message-ID: <TY2PR01MB5257BE671A481D81F1A40E0185209@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
 <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
 <825b8b72-c746-ba24-7142-3fff481e82d6@linux.microsoft.com>
In-Reply-To: <825b8b72-c746-ba24-7142-3fff481e82d6@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2022-01-26T04:18:43Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=97adb032-473f-4dc0-8014-2451c4f91de1;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0686a90b-2865-4946-0acd-08d9e0b572ed
x-ms-traffictypediagnostic: TYCPR01MB8390:EE_
x-microsoft-antispam-prvs: <TYCPR01MB8390B004370546669E4DCA2E85209@TYCPR01MB8390.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 44BjdIFSxdJ3j8O7vmd2ijLwy/ltyjLIPpgR8igZAxDvvWQpTLPc0G8xKRwJHVt7Qr1Ieg/xivSmBlHHnOlYepIuqeMNg6b46xSxieAZlwJLvmui+MF5L3dTt/4KcEy5N0KJvY2NKvoybrPFREaOfvQP7xfzZivOXQnPCi89yRy37qlB6dcR8A4rjYr874fOPcrtZIDZvZJF5JeMeobJKYjotzzgThiiSw4Gx2lC4BM7fil1BLVDw1klIaeKzpNLOQxImL2AkMaFnpg4ZeSrrIp6HP4mxqFnSzUrd5vkIZtf1FtejpfBnPCPVEUWW80Urt5QD5c+RQuVrGQCI++v2pUDHsHG1JbcoCJZDDBOm0ER2bV9Eo9FyZU+RuRdynyuj27w2PDwmQVdusj2HhIaHHPEnaBpCYYNC0iCSogtBtV3rOuRbHfWCSB/PmIQHhQcrT1t8A2U4hdcZPqb7rP0+BM/JbyL56m+C4AEmP1vnQOOeCSdBGI7DMZYitz3foLUxFIeDCq5x+7PXrGiFWFLzcQD980dghO++5OdsD0AIW9Wbrx6Dr2owvO1Ex2kevSSQARBn4JURJ0HvfEd/V5F5DVF5jeUXqsd2RKW5Oc3eCWvZBpJ7s8b8184LhgtusZ/YZRd22oNHfnQmwdlZ111q3k0n4mfrIN3NCmhYxXTaWaXY1zlv8xSeQmx4r0Cjn9JFnoJZKm1FCICAqEDwwa9Iu1Eh8q0+0QxmXiNuhjIWGRTfJeYJEh0P2wZqjGLSIThI14sL/lZ5iDcvhDA5KcX9vdc7Pncv/tN3f9KDG5vCW5obpiBz4lqqjUmNdknevMw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(921005)(71200400001)(38070700005)(38100700002)(7416002)(82960400001)(5660300002)(85182001)(110136005)(8936002)(66556008)(66446008)(76116006)(66476007)(7696005)(66946007)(316002)(64756008)(8676002)(55016003)(52536014)(6506007)(966005)(83380400001)(2906002)(9686003)(508600001)(53546011)(33656002)(26005)(186003)(86362001)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?U3FRbkhOMVJOTmJ6YzVRYmJiODZSQWdRU2pVWTJreCs4VjVCTjNpeE1X?=
 =?iso-2022-jp?B?b2wydHlBYjR6TEliY25PelUyY28xQjBZdFhsUmduMTJ1NGNkemlBUkRz?=
 =?iso-2022-jp?B?eXJrdk5va0ZJdk0rRTZHNEJNYjluZnA4dFdSM0pHaVNVeE5mVE1wbWdJ?=
 =?iso-2022-jp?B?QjdLeGtLZ3RnajVYNUJwZS9zbmh3NXRjTXk3VWpFQmZIbUZRQURsNUc5?=
 =?iso-2022-jp?B?ZHBZUzlTRGxkK1hYcFJvZnkyVEFKc1ZORyszOXNXWWV4dDRLYU1tSit0?=
 =?iso-2022-jp?B?MkZBeEQyQXNIK0EyL0g0bEpDWWZXUEFzSXpGcnRSZ3hBT0tncjRweUFk?=
 =?iso-2022-jp?B?cTlDUk5LMXBIUmhkNHBZczRDQXJqQmh3eExNT1dkMFkzcXJYR084Tmxr?=
 =?iso-2022-jp?B?NklaNWpwUHIvdys2eGtHdWNmeks5Vi9QdlI0ZDAvOTdSaTdVZVgvVGZL?=
 =?iso-2022-jp?B?UjVubWljeldNOEo4cDhJeXA3enNhZk5FenpneDgwNDh1bkwrc3RMSUxw?=
 =?iso-2022-jp?B?MDI0aGxDdFFEV2VOK3hCajFtOENtZklKc2xHdjdlR1FuNE9NQVJEQjlJ?=
 =?iso-2022-jp?B?UWdoVzk2aVJNVnBCdHBKem5NaXowSnhwVFAvZVh4RDBqcmVabks0KzY1?=
 =?iso-2022-jp?B?M1g2MHlZZzNlNlUxQnJ2YWVGcHB6QXB3bXJROGtOL3dxWGM5NnN4YVE1?=
 =?iso-2022-jp?B?clVYbUsvVnlnVm9pRFFwd3FFeHdDRGFGQVgzM3N2TllOWUM3RGpkNjVS?=
 =?iso-2022-jp?B?NitCM1JUcFlHWWVPMzdwMVZMK0NZL0JWVzNZUXdpQU5Zb0pLbTBPTlhD?=
 =?iso-2022-jp?B?YU5pZHVyN2w3RnJsWklBK3JuSHJrbDVhZ2g0N0k3blRPM3pTNEd2dXN1?=
 =?iso-2022-jp?B?c2MveWhFRGZ3cklPRDAxTDdLdjZkVitCWW9ONEJiNXlrQkJqc1hWc3pQ?=
 =?iso-2022-jp?B?WXlMT1JpMlk0VUhIcjVsOGNkZjhsYVRsM0s5ODc3QmdQSEw5MzYvVEpB?=
 =?iso-2022-jp?B?T1VqblRveXVwb3dkbUJpbFV3dEFsNFRZNzcyMGd3VUZ3Rmd3TWcvcXl2?=
 =?iso-2022-jp?B?amxiZS9ubWZrakVZZTlvdmxWbHhBRnI1cWtOQW8zWWhJUVVIaEg5S0dS?=
 =?iso-2022-jp?B?T2huUFdRcjVWNUUxdVB3MVBIVTJ4aVNCTXJBZzA0akJYQ05sSTdCRHNz?=
 =?iso-2022-jp?B?SnhhMVl3VDhtL1J0THBPcFYvR05rK1RIL0tLTzROcUpQNlI2RmpkQW1X?=
 =?iso-2022-jp?B?Kyt5ak4rcWZ3R3J4OS9PZmNTTVR1N1JBTnBOREN5MkdicFdqRExTRjZB?=
 =?iso-2022-jp?B?YUEvcHNqOUlROUZLcHpzV2NsMDJiL3Boc3FFTEV5QThibWFTeXhUZ0NF?=
 =?iso-2022-jp?B?UGdYR0NvZWZDOHpZTGU2RGtZdFVJbjd2V0pZNVpST21KVktaNHhnaVFh?=
 =?iso-2022-jp?B?NEFlYmdla1REMk1TdkhEL2t1Wm9TRHQwODhJUUF6aHdRR0lEQnIxY2gv?=
 =?iso-2022-jp?B?dFNsQ1Q2NjRiQ2JLK0gzdm5pYlZTN2daLy82MlE0b2NsaWhmSnBIZnJZ?=
 =?iso-2022-jp?B?M1M5NkZLbHg1ankzZHJ6YnI5K3ZwT0FscFArTWkrbVVVbXdQcGpueHcz?=
 =?iso-2022-jp?B?b1J6eUVMdXpHK0V2OGFER3dpaXJXdVRXN0tlUkJhdVNBRzdvWmVFMzly?=
 =?iso-2022-jp?B?c29CTjdHc0JFbUhWd0FUUmZuQzNGN0I0MXBYZENvUGMvZE5KdUErT0k2?=
 =?iso-2022-jp?B?aVRhUm1DbDhGZE12amMrcTBQYnhEK0p6QmF0QmVCZGlmeEc5V2hLWkFE?=
 =?iso-2022-jp?B?SmlJdGt5RWMwMXVWR1g4UGU5dGc0bE4ydnJOYXN3WHVMR0oyR0RWaU11?=
 =?iso-2022-jp?B?R25YdVlzUmFnaDlNckROUUhtL2tqb1Vyd2pHMFVWRVkvd3FoM1ZQL3dJ?=
 =?iso-2022-jp?B?alQvbHUyWERZU1drQlVCYjdLTUt0YzVYSzV0WXliWEpwb3hPbStHUmpD?=
 =?iso-2022-jp?B?eW80TVBGRWNYMEdpNm4zeUh1bnBWM3FHWWNiSEIybThiSWNVUUlaRXBs?=
 =?iso-2022-jp?B?NmN0SStSZWZ4OU5vWFBTOGJhaWNYQmhKVDk2UUpIblJKZnN3enpTYjYr?=
 =?iso-2022-jp?B?ZVV4K0xPd1B1RkkzR0pYUkM0cm5QUkVtRmVycVZ3K29uc3ptQ3NVVTh6?=
 =?iso-2022-jp?B?L09GSUV5WS9hRmhwSUU4aTFSNTVYNnplMHphZnZOOFpUcElBcDJoVWp3?=
 =?iso-2022-jp?B?YmkrZzJRRFVwV1BteDk2aVQ5QkRvakx3b3hKV2U5ei9LSG45S1VMazNX?=
 =?iso-2022-jp?B?cStNSDlBMUtRSmNIMFdHb0pXREREUXNpUWNnMk1DUm1jRnNyYkJudEhQ?=
 =?iso-2022-jp?B?by9Bek8yZFFWOUJxVkt5Qm1SbzJRT1hhaTlVMkVTWHk5c01kRWozQ2NS?=
 =?iso-2022-jp?B?WUlkRHN3PT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0686a90b-2865-4946-0acd-08d9e0b572ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 10:20:17.1006
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YY98+pJ4i8DkdzlQDsaPg7+RPxOKBuxAEqwLZQCI6+gwnAlPCt4hW/dfrT0DsvxVq0c7XwpwKEyfAbSb1O+zs2bnq3HzEZfGhKdpvrxAi3M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB8390
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> I have not seen any activity on that in a long time. IIRC, Julien quit Re=
dHat.
> I don't know if anyone else has taken over this work in RedHat.
>=20
> Sorry, I don't have any more information.
>=20
> Madhavan

Thanks for your information.

By the way, I'm considering test code for arch_stack_walk_reliable().
Specifically, I apply Suraj's patch to enable livepatch, and added a functi=
on
that sleeps between SYM_CODE_START and SYM_CODE_END, then livepatch
checks if the task has an unreliable stack.
For now my internal test code working correctly, but my Kconfig excludes
STACK_VALIDATION dependency.

It seems that objtool will not be enabled yet, so I would like to test it e=
asier.
If you are already testing with this patch, could you tell me how to do it?


Thanks,
Keiya

>=20
> On 1/24/22 23:21, nobuta.keiya@fujitsu.com wrote:
> > Hi Madhavan,
> >
> >> Select HAVE_RELIABLE_STACKTRACE in arm64/Kconfig to allow
> >> arch_stack_walk_reliable() to be used.
> >>
> >> Note that this is conditional upon STACK_VALIDATION which will be
> >> added when frame pointer validation is implemented (say via objtool).
> >
> > I know that Julien Thierry published objtool support for arm64 [1],
> > but I'm not sure if it has been updated. Could you tell me other thread=
s if you know?
> >
> > [1]
> > https://lore.kernel.org/linux-arm-kernel/20210303170932.1838634-1-jthi
> > erry@redhat.com/
> >
> >
> > Thanks,
> > Keiya
> >
> >>
> >> Signed-off-by: Madhavan T. Venkataraman
> >> <madvenka@linux.microsoft.com>
> >> ---
> >>  arch/arm64/Kconfig | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index
> >> f6e333b59314..bc7b3514b563 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -223,6 +223,7 @@ config ARM64
> >>  	select THREAD_INFO_IN_TASK
> >>  	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
> >>  	select TRACE_IRQFLAGS_SUPPORT
> >> +	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER &&
> >> +STACK_VALIDATION
> >>  	help
> >>  	  ARM 64-bit (AArch64) Linux support.
> >>
> >> --
> >> 2.25.1
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
