Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9209445348
	for <lists+live-patching@lfdr.de>; Thu,  4 Nov 2021 13:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhKDMtp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Nov 2021 08:49:45 -0400
Received: from esa3.fujitsucc.c3s2.iphmx.com ([68.232.151.212]:8219 "EHLO
        esa3.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229809AbhKDMto (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Nov 2021 08:49:44 -0400
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2021 08:49:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1636030027; x=1667566027;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=6gpWSTJfFFAtRBtfprP/NTINsQMn+3ajx20hPnTFiNU=;
  b=q0dBr5NOpRHqTIQxYe/q0z/OgfDrtvpiYm6NoS07ZisVFrMosmBPuFn7
   8wzmHcqNxHtsP7Ta6AfpQb9hBG3YyTgaquany44926y53zXCksOCvB7sw
   +QSvmM37lLE2DZ6V3bGVxexhFmI7YIUMTC74cKlSzaHjNDnaNRUqepPXg
   /8cS7SNyxQXhEL7I5hc844sBUm0DRSvAN1Z0sUOP9VAtX8XzGXsAqiakE
   POP4WBgyrLzZMm/lmYqCHwAd+YnVmxg4WYOzbdixDfRLkEcAUOIhNVUYu
   Zim5xNLglfJFtczV4eO34mJxzaqQFvQVvQdwhehwWc4lulWV8Hca9Xa+O
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10157"; a="50945909"
X-IronPort-AV: E=Sophos;i="5.87,208,1631545200"; 
   d="scan'208";a="50945909"
Received: from mail-ty1jpn01lp2056.outbound.protection.outlook.com (HELO JPN01-TY1-obe.outbound.protection.outlook.com) ([104.47.93.56])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2021 21:39:52 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcTFUN8vv/8C+ZYtKpNGBIeD08slEfLbMpk61ztbRdnjPgpcj9um5Px6AW5UZjdibCZ7KJYMD2EkJcTR2TPQt1SHytM35mqDcSlg6eI4ybI9lhIBuQRmql0gq4F61+NvaLTria6H3zXXBfjiXr4EZ2ssCINnbfum+rm5w2A/QgWQZniyY0pk5utRvgHMX6na4wsvfq/2d6m4ja8fKZIJNvdC73Dk1WDdpmLIvA9g/7G9B7ds+k/vcmfOo1pC/CrHASMnx6TzpevF9r/igoAoUSfpguss5P4uDEnPVhN+JbChWSFZQp0HPVdN53XNTnON0SeGuS11e6qryuHkFmh2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BaCK0pVI51/Lhl5Dd6LeLUgBKwYwi5T8uIMTdvD+EjI=;
 b=a6tWpGTnqmT7e6ok56OqIh1iEjFhtAAK6ek94QRx81Q8hiu+dHsDUhD3b1qXSvzw7iY4uZDBJRRnAecJQ0DPcFQPoUuFb5QlJSiXgwis9T9XtCaxEbqe15RdB9sjSyclwQ1YVhnSbhQRb/H8YwtxUiBTQEMj/BQPVL+QFg2dVrt4IytGGVtnv8u6nIxHcN6A2+/BYujGn3iGLKMcKEysL1JJlqlMj8HaaUS1CQ6b+etpxX5zdv3LEXFqDjL+NlBLcdL8u/6b87hr9BfeUnZORccnTR4pab0keyLzKjUWCjkVFpTAclJ6AFeFGgng0nDEWiAXuPrvEfPPY82mbKWoaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BaCK0pVI51/Lhl5Dd6LeLUgBKwYwi5T8uIMTdvD+EjI=;
 b=IVcTKs5Mo7QM62EQSIVvKbc9dBeqGWQMhT5p+iSRwfFxDCclaqC/y3CwVqW4V7GJqicWh8rSJIRqPfGZPafCGNjIMV6FSIF6/5H0pYArbY0EKPy5vVzzQQeLUZzd6EoLcAAS4yUnyCbIE+tLOHZfyPSAce2FZP+d5vdg4Ns3gdc=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYCPR01MB6915.jpnprd01.prod.outlook.com (2603:1096:400:ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Thu, 4 Nov
 2021 12:39:49 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::3115:35e1:f76a:df06]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::3115:35e1:f76a:df06%6]) with mapi id 15.20.4649.021; Thu, 4 Nov 2021
 12:39:49 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
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
Subject: RE: [PATCH v10 10/11] arm64: Introduce stack trace reliability checks
 in the unwinder
Thread-Topic: [PATCH v10 10/11] arm64: Introduce stack trace reliability
 checks in the unwinder
Thread-Index: AQHXwXCrRPC5fqZO6UKyUYkcxaNwkavv6hng
Date:   Thu, 4 Nov 2021 12:39:49 +0000
Message-ID: <TY2PR01MB5257314F9E704259AB3F61F5858B9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-11-madvenka@linux.microsoft.com>
In-Reply-To: <20211015025847.17694-11-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-11-04T12:39:48.995Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
suggested_attachment_session_id: 4ac71e89-fd4a-a590-01fc-6d461a373252
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c85d55c-3785-4031-1d2d-08d99f9030fb
x-ms-traffictypediagnostic: TYCPR01MB6915:
x-microsoft-antispam-prvs: <TYCPR01MB69151FAE65E313725E3334E2858D9@TYCPR01MB6915.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yc1vP/U1Chn89yStkbhZRlYBSXRfAetewhhyHgirHbwsjnbR6vbCRKYY2Q/Yb1wxf7yAJZH9cynT8uh5jmXpp4mjy+jSy/N/bzAUISt5XefRi4fy3LusRuVGkoRqcxRooTD+FBFCcJnHV+uMNNN3eDBD4BJ88Q7SPvqiUm8i0Cev7sDEP1zUAm1FjBcC/ezCfInlMAm72MRE8d6KgVMmUnj5zTBwhiyQRFwhHqNm5//WS1xjdlXZHM37j+s/DTAlYJo3b1e0rv8ZGBS0yoPn1Cgft99k9gwFbqxFkhzqiPdi7fSL3djS0MFoZD1Bm/5kG5cpsnwpDLpRvcH/aRaflByUfx14pxQTjIkvuhsm0+JTcKvudNsHWiQEiZn4WBbc5MZiyFyL+qPj/88dAB/+s/sfGmls5rkHU1ALHQcVJ00PBlElJM4CI1MHbcy9cpANDdIjMCUYohSxdeW5nviFGVAk8LkYBTSyzlWLaHQFJ458WUjmQLfi4w7xcL+5JFPaBIKBLGziq+5bJlZgMJhmum5qbEtG+zsTNBbgR7qyBGFknBY+9PUYaOqB0UqSjn0bEzUarRE/5DSBKa6YUHceWTPgwSnQO+o7xd5qCzc1DHUskJkBNy76xqsaxoTiJ0HioyCk6A6EZZSGhGXqVuZcGPtzlMAqg33WTQolsfNpUpqqf8F+/IpEDlpibHyatp5hW/3Sdy1190QSTUauiE3iWShLzhWSo2cxnVXfcCxjNqM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(316002)(52536014)(2906002)(38100700002)(53546011)(83380400001)(122000001)(7416002)(6506007)(5660300002)(921005)(8936002)(7696005)(110136005)(66446008)(82960400001)(26005)(8676002)(66556008)(71200400001)(76116006)(9686003)(186003)(85182001)(66476007)(38070700005)(55016002)(33656002)(508600001)(64756008)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?eE0yTm5BUGdrZmpOTGFYU0FRNnV6bmxVMkxRczFMMForcU94WDE5eVE0?=
 =?iso-2022-jp?B?TXBTdUVacE9rQ1ZVRC8zaXkva1BJOG9tdmtQVWF1VHhMUTZsTkIraVFs?=
 =?iso-2022-jp?B?N3NSQ29oV1YwdXkrdklDVFlxYVh4UC8yR0FrR09rS0p0ckEwZFNFcEhU?=
 =?iso-2022-jp?B?UTRXMXNCaGhpVTNLZjRaMUVlSXFiemdZY2plZy9vTGRmYkoxV2Y5a0VR?=
 =?iso-2022-jp?B?WXU1Sktrdm1mbXVTUHdtakFjNHBlWnBpSXBYYy9BSld5KzN5cXptSTgy?=
 =?iso-2022-jp?B?NnQ1NXhnY2pYS3Evem15K0Y5Y29DY1JSWGFXVllTTU9pUU5XRXhDcUkx?=
 =?iso-2022-jp?B?Zzl1WXM0Vk9lTTV2WjJZYk84Q1FjV0g1ZG5aalhacVpWckUvOXpVOFlr?=
 =?iso-2022-jp?B?WDJ2QTVnR2ZuSGdldG5idUVWMkdKUGlQRjZQMXhHMDFyMjNOcy9IcWhz?=
 =?iso-2022-jp?B?WExVREQ3bXBwKytTUXVOam1COWs1VC9LS08rN1lNbSswT1ZkU2s4TG1z?=
 =?iso-2022-jp?B?MlQ2aTV1M2NVbWFMa01VNHJPeWl4WjltYTR5Qk83WFV6SkpYK0NVbGZi?=
 =?iso-2022-jp?B?d3dRUTc2aGFNTituMnBzdklGaXF2RmdUSENMdmJoSlpRaHFQeGZTdEkw?=
 =?iso-2022-jp?B?ODJ0T0h4ZUZ1Kzc1ZjU1VUdudncyd0o0ZVYrdTBCR0dTbmEvRFc0cEQx?=
 =?iso-2022-jp?B?TjdDN3dBMlVLNkVkWE9tZjFCSUFrVGlJSzhrWk9jOVo3emsrMWNzeXdT?=
 =?iso-2022-jp?B?Yk43SEFKMG1vamlOVGRaNXNkNHhEczN4VCtFYVQwcmlKeGNOcTZKNjlu?=
 =?iso-2022-jp?B?aWRmbVJBNENOcnROVVJJaS9xUE5hT1JTUnNybDJBdysxemVxYVVzWFl4?=
 =?iso-2022-jp?B?cnlKeTBRSmhSOFVReWhoYkpTWVU4Q2cxQVI0WFAvbDNDbk1zYU1ZeDNx?=
 =?iso-2022-jp?B?ZnpOZVlPeHV2ajVjNDB2ODhkYmNSeVBDQjlQK3NoZnE2cUNOL1BtMVVp?=
 =?iso-2022-jp?B?dEhERmR5YnZzN092VnJCV2pOWTN0QUp6NDVYRVlkalowTFBweVI3SnI0?=
 =?iso-2022-jp?B?cDRodEFGc1BxZlMzNCtMdW5EelFOdjNTNi8yVUFveVhmeExzK0dXbzNq?=
 =?iso-2022-jp?B?RVpEbTFRNTcwSENVTEJlWm5tdTN3QXhFQjVrZTNDTnZhckgxVEdKMC90?=
 =?iso-2022-jp?B?bUF5azQrM245TW1lWXJXZzc4MHA4RnowcXN3OFVkZnpWd3JvRkE0OU9n?=
 =?iso-2022-jp?B?SjRaTERYUTJlWlpHZEt1L1hLaDc4V2tjNXJadGR1Y205Z0k4WkdVMW5i?=
 =?iso-2022-jp?B?QXp6bmUzaExNbU1BWFJocGZDeUJHd3NtVlQ5TTUyc1lhWkkzdVRKNk9H?=
 =?iso-2022-jp?B?bFpDNFFLc0gvYkQrclczZ2xYeTZEc2p6Q0lsQUVGS0dpYm5BL2RPajNm?=
 =?iso-2022-jp?B?QTFjR1NETU9jbTVHdm5jaGtNa0cwcXk0d0dhc0ZmTXhKS01IZ0RESjgv?=
 =?iso-2022-jp?B?NmlMT05Sc2h1d3Q4N2Z5NHd6YW1PWG1Ra0pBa0dBbWN4NnFwOUdMQkJm?=
 =?iso-2022-jp?B?bnVwS1ZTSlMrRENDaisvMThYZ1RHenJSYjY0R2RMc2RFYWpvcWdTbUdC?=
 =?iso-2022-jp?B?R3R1TmpZU0Y2OWhFWnloOFJTUGNQaEdxY205bUNvZDJrM3JoTGo0dFhQ?=
 =?iso-2022-jp?B?VFFFOXhKMHE1NDQ2NHBLMitBSFV4UjBwM3ErR05sV2pPNFNvT1VtbThZ?=
 =?iso-2022-jp?B?SmVVL0QxdjNhS1hmQXRpNVJ3SDRxN042N0NINGpzcFRSNzRNaTN1V2pu?=
 =?iso-2022-jp?B?TklrcDdCZGtsaDY3bEpnWDdBZjdOSjhsMkorWXZuZTMrTWNwWFFyd2Uv?=
 =?iso-2022-jp?B?UVZxaW9XcHRjS21VUEt0ZUlQNTVzanlHVDFZanlJL2JwcW1FaGpIbzdt?=
 =?iso-2022-jp?B?TGorZGMzVHJ0STBIUExET0I4WklJMGFpM0p6ZG9yMVNta2gyaThBQ2tJ?=
 =?iso-2022-jp?B?MFpZa3FsY0owQ1RwamV4SEFtd0xVMXBCaUVQK2o0SXMxcWc4U2VRanA1?=
 =?iso-2022-jp?B?Smd0c1d6ZWJzL1d3S0lwaWhtV2FnYndZVnRzTEliWEpDYnBOSm54U2ZE?=
 =?iso-2022-jp?B?UjUwR0Z5V0t6YndOZS9jdm9YS1F6MHNVTlhlaHJVSmhYeE1SMFB3NStt?=
 =?iso-2022-jp?B?U1V4bGtCSE55VjRFZlZtTGFnZklLS0RWbjR0ak5XODRxRnpzc1pqVWhh?=
 =?iso-2022-jp?B?citMdmMvNjFkTGlhSW5SM0VDNjBOT0VrQWtiek5HeXhUVXNYNXB6cURH?=
 =?iso-2022-jp?B?dFUrRVJLN2lGZEZaTzFON2EzUmRtN2U2WWt6eldhWUtoWjRyUUpwdFZK?=
 =?iso-2022-jp?B?K0xORE9DRktpVjkxdVBGcHFlN1QybHdQVWFqYTVqY3hXVW9YUXJkOUl3?=
 =?iso-2022-jp?B?bUwrWUR3PT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c85d55c-3785-4031-1d2d-08d99f9030fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 12:39:49.4336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/PK0D5SW0W7gUuVUZfk2N97fRoszLIGJxTAGJlIAf8kuXlzASlrcxmpgL4vKy0RXD0siG2//4a4tNm63Yxy870ZZ3f6dpPXxGyUNiRlegk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6915
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,=0A=
=0A=
> -----Original Message-----=0A=
> From: madvenka@linux.microsoft.com <madvenka@linux.microsoft.com>=0A=
> Sent: Friday, October 15, 2021 11:59 AM=0A=
> To: mark.rutland@arm.com; broonie@kernel.org; jpoimboe@redhat.com; ardb@k=
ernel.org; Nobuta, Keiya/=1B$B?.ED=1B(B =1B$B7=3D:H=1B(B=0A=
> <nobuta.keiya@fujitsu.com>; sjitindarsingh@gmail.com; catalin.marinas@arm=
.com; will@kernel.org; jmorris@namei.org;=0A=
> linux-arm-kernel@lists.infradead.org; live-patching@vger.kernel.org; linu=
x-kernel@vger.kernel.org;=0A=
> madvenka@linux.microsoft.com=0A=
> Subject: [PATCH v10 10/11] arm64: Introduce stack trace reliability check=
s in the unwinder=0A=
> =0A=
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>=0A=
> =0A=
> There are some kernel features and conditions that make a stack trace unr=
eliable. Callers may require the unwinder to detect=0A=
> these cases.=0A=
> E.g., livepatch.=0A=
> =0A=
> Introduce a new function called unwind_check_reliability() that will dete=
ct these cases and set a flag in the stack frame. Call=0A=
> unwind_check_reliability() for every frame, that is, in unwind_start() an=
d unwind_next().=0A=
> =0A=
> Introduce the first reliability check in unwind_check_reliability() - If =
a return PC is not a valid kernel text address, consider the=0A=
> stack trace unreliable. It could be some generated code. Other reliabilit=
y checks will be added in the future.=0A=
> =0A=
> Let unwind() return a boolean to indicate if the stack trace is reliable.=
=0A=
> =0A=
> Introduce arch_stack_walk_reliable() for ARM64. This works like=0A=
> arch_stack_walk() except that it returns -EINVAL if the stack trace is no=
t reliable.=0A=
> =0A=
> Until all the reliability checks are in place, arch_stack_walk_reliable()=
 may not be used by livepatch. But it may be used by=0A=
> debug and test code.=0A=
> =0A=
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>=0A=
> ---=0A=
>  arch/arm64/include/asm/stacktrace.h |  3 ++=0A=
>  arch/arm64/kernel/stacktrace.c      | 48 ++++++++++++++++++++++++++++-=
=0A=
>  2 files changed, 50 insertions(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm=
/stacktrace.h=0A=
> index ba2180c7d5cd..ce0710fa3037 100644=0A=
> --- a/arch/arm64/include/asm/stacktrace.h=0A=
> +++ b/arch/arm64/include/asm/stacktrace.h=0A=
> @@ -51,6 +51,8 @@ struct stack_info {=0A=
>   *               replacement lr value in the ftrace graph stack.=0A=
>   *=0A=
>   * @failed:      Unwind failed.=0A=
> + *=0A=
> + * @reliable:    Stack trace is reliable.=0A=
>   */=0A=
>  struct stackframe {=0A=
>  	unsigned long fp;=0A=
> @@ -62,6 +64,7 @@ struct stackframe {=0A=
>  	int graph;=0A=
>  #endif=0A=
>  	bool failed;=0A=
> +	bool reliable;=0A=
>  };=0A=
> =0A=
>  extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk=
, diff --git a/arch/arm64/kernel/stacktrace.c=0A=
> b/arch/arm64/kernel/stacktrace.c index 8e9e6f38c975..142f08ae515f 100644=
=0A=
> --- a/arch/arm64/kernel/stacktrace.c=0A=
> +++ b/arch/arm64/kernel/stacktrace.c=0A=
> @@ -18,6 +18,22 @@=0A=
>  #include <asm/stack_pointer.h>=0A=
>  #include <asm/stacktrace.h>=0A=
> =0A=
> +/*=0A=
> + * Check the stack frame for conditions that make further unwinding unre=
liable.=0A=
> + */=0A=
> +static void notrace unwind_check_reliability(struct stackframe *frame)=
=0A=
> +{=0A=
> +	/*=0A=
> +	 * If the PC is not a known kernel text address, then we cannot=0A=
> +	 * be sure that a subsequent unwind will be reliable, as we=0A=
> +	 * don't know that the code follows our unwind requirements.=0A=
> +	 */=0A=
> +	if (!__kernel_text_address(frame->pc))=0A=
> +		frame->reliable =3D false;=0A=
> +}=0A=
> +=0A=
> +NOKPROBE_SYMBOL(unwind_check_reliability);=0A=
> +=0A=
>  /*=0A=
>   * AArch64 PCS assigns the frame pointer to x29.=0A=
>   *=0A=
> @@ -55,6 +71,8 @@ static void notrace unwind_start(struct stackframe *fra=
me, unsigned long fp,=0A=
>  	frame->prev_fp =3D 0;=0A=
>  	frame->prev_type =3D STACK_TYPE_UNKNOWN;=0A=
>  	frame->failed =3D false;=0A=
> +	frame->reliable =3D true;=0A=
> +	unwind_check_reliability(frame);=0A=
>  }=0A=
> =0A=
>  NOKPROBE_SYMBOL(unwind_start);=0A=
> @@ -138,6 +156,7 @@ static void notrace unwind_next(struct task_struct *t=
sk,  #endif /*=0A=
> CONFIG_FUNCTION_GRAPH_TRACER */=0A=
> =0A=
>  	frame->pc =3D ptrauth_strip_insn_pac(frame->pc);=0A=
> +	unwind_check_reliability(frame);=0A=
>  }=0A=
=0A=
Isn't it necessary to check "final frame" before unwind_check_reliability()=
?=0A=
The frame at this point is unwound frame, so may be last frame. =0A=
=0A=
Or if move unwind_check_reliability() into unwind(), I think unwind() can=
=0A=
be twins as below:=0A=
=0A=
~~~~~~~~=0A=
unwind(...) {=0A=
	<...>=0A=
	for (unwind_start(...); unwind_continue(...); unwind_next(...))=0A=
		unwind_check_reliability(&frame);=0A=
}=0A=
=0A=
unwind_reliable(...) {=0A=
	<...>=0A=
	for (unwind_start(...); unwind_continue(...); unwind_next(...)) {=0A=
		unwind_check_reliability(&frame);=0A=
		if (!frame.reliable)=0A=
			break;=0A=
	}=0A=
=0A=
	return (frame.reliable && !frame.failed);=0A=
}=0A=
~~~~~~~~=0A=
=0A=
=0A=
=0A=
Thanks,=0A=
Keiya=0A=
=0A=
=0A=
> =0A=
>  NOKPROBE_SYMBOL(unwind_next);=0A=
> @@ -167,7 +186,7 @@ static bool notrace unwind_continue(struct task_struc=
t *task,=0A=
> =0A=
>  NOKPROBE_SYMBOL(unwind_continue);=0A=
> =0A=
> -static void notrace unwind(struct task_struct *tsk,=0A=
> +static bool notrace unwind(struct task_struct *tsk,=0A=
>  			   unsigned long fp, unsigned long pc,=0A=
>  			   bool (*fn)(void *, unsigned long),=0A=
>  			   void *data)=0A=
> @@ -177,6 +196,7 @@ static void notrace unwind(struct task_struct *tsk,=
=0A=
>  	unwind_start(&frame, fp, pc);=0A=
>  	while (unwind_continue(tsk, &frame, fn, data))=0A=
>  		unwind_next(tsk, &frame);=0A=
> +	return frame.reliable;=0A=
>  }=0A=
> =0A=
>  NOKPROBE_SYMBOL(unwind);=0A=
> @@ -238,4 +258,30 @@ noinline notrace void arch_stack_walk(stack_trace_co=
nsume_fn consume_entry,=0A=
> =0A=
>  }=0A=
> =0A=
> +/*=0A=
> + * arch_stack_walk_reliable() may not be used for livepatch until all=0A=
> +of=0A=
> + * the reliability checks are in place in unwind_consume(). However,=0A=
> + * debug and test code can choose to use it even if all the checks are=
=0A=
> +not=0A=
> + * in place.=0A=
> + */=0A=
> +noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn con=
sume_fn,=0A=
> +					      void *cookie,=0A=
> +					      struct task_struct *task)=0A=
> +{=0A=
> +	unsigned long fp, pc;=0A=
> +=0A=
> +	if (task =3D=3D current) {=0A=
> +		/* Skip arch_stack_walk_reliable() in the stack trace. */=0A=
> +		fp =3D (unsigned long)__builtin_frame_address(1);=0A=
> +		pc =3D (unsigned long)__builtin_return_address(0);=0A=
> +	} else {=0A=
> +		/* Caller guarantees that the task is not running. */=0A=
> +		fp =3D thread_saved_fp(task);=0A=
> +		pc =3D thread_saved_pc(task);=0A=
> +	}=0A=
> +	if (unwind(task, fp, pc, consume_fn, cookie))=0A=
> +		return 0;=0A=
> +	return -EINVAL;=0A=
> +}=0A=
> +=0A=
>  #endif=0A=
> --=0A=
> 2.25.1=0A=
=0A=
