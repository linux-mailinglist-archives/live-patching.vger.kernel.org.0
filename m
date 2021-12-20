Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30A647A40E
	for <lists+live-patching@lfdr.de>; Mon, 20 Dec 2021 05:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237360AbhLTESe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 19 Dec 2021 23:18:34 -0500
Received: from esa8.fujitsucc.c3s2.iphmx.com ([68.232.159.88]:35747 "EHLO
        esa8.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230231AbhLTESd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 19 Dec 2021 23:18:33 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2021 23:18:32 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1639973913; x=1671509913;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WA40hioy3Erpb5Phm+9yDwaBLPnVVudaG+FgNqp4ht0=;
  b=TJG7wG20ih9D6LDDM7XP23hUHV85T4iIjm8XGHIILPnGt2NLwVC9Gy4s
   ogZ6mKxjx2RJO8hpghwZ9WY2x9plIbyCOM1tK+HLN/YmTnN7EA/eg2zuY
   GLjoBpsRhQUpjgPjIhhtaBOarjFQqs6aJpGGNcoqgMNLhHVGc477muftm
   Mr2DowwRD6zMX86iVN3rfLBVgpwrRzUR8DpiXEyzWdymBXwvWA3i1JGC2
   uuVSTL5lwWghkqrOLqvxaj1edjz++RXtAC1oivCySNKWAsjwLMo/I7Ylh
   kAXNLp0DlTTkTW33LfoUVTGPZ8Tdj8lH0/WkfTJrwZoXNDBMbC+KFRh//
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="46168389"
X-IronPort-AV: E=Sophos;i="5.88,219,1635174000"; 
   d="scan'208";a="46168389"
Received: from mail-os0jpn01lp2112.outbound.protection.outlook.com (HELO JPN01-OS0-obe.outbound.protection.outlook.com) ([104.47.23.112])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 13:11:19 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O6kp8H2WRwCngHgb+QMKOqALhp0tgwpKA3D9WeZ/lch4hJCEk7eTsbCtcGQUYwvbwBOiES7mPgewXYiR02C1CFcpQmorIMIC7/eMRqfxLMh7TdornZqZ9ixbHu+1Th4ykG1vlgM23IW/+i76i1zEvOSwyNvOMcdY/6H0F58FCKbjSRiaZtDFjjowPZ6C/FznYsuHGnW/6Rv6SzLVhWvLUyY6snHMfhsb8VjUolfHoCGZN0p5QK+e1pp6BefNPMmsKvM7V19jk9ezuWNR5jsoDRnk/vQYjDy3C++GLgFu+Q18Di7py5aVLb6cxYjTJztK65DhexywH2zrGbVv+RT/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khwjDo3vuGsNk4tryWCKz2klpJjLrreLMoVKV6AMmh4=;
 b=USeAuGm3OKKOvky/gIZGqlHQeKPIHhvHj6JY3aw+MVC1ZI39e2JHS9grgo5vrGYtMMPzkD7okoH3HIQcX9Sw9KtnOOwqTu1qK7SSM+Q2/zsxdDkkHgYyQ8e9Iet7HzYl1CIQbEbskdan5rHtKIjqXX0AU1hgsy9k0GATh+oU9xmAbaG9A5WacW5JzeyqMC1V6njAc2rik+Ex866NSWP9QIAX+BG+32FwRja2N0SkO2x+U6XS0d3NwQDmmjETBnPC8vJl/XhkibomU7BkZXZO1mQdOl+L5VHaLV7R8Wt5AWUTsq5/oVpxCZtkrHmV6z84toFaC7tlgVXRdB+crzndQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=khwjDo3vuGsNk4tryWCKz2klpJjLrreLMoVKV6AMmh4=;
 b=kFJacMN/jGMr566USj03INOrmzco1L0MISnPF5UhWgTVPSE+/9jysIRycGOjjN0K1OH7eTpNJ9cYs7S07k7g+ZUJvX6p3YF8351B3xhLANW9Rk5bAUZgoDgypORatE5ADDx5D+e0DgKoqhZGxZRKmAJ3ZJkHfOzIEle3xwsuJNE=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TYAPR01MB2991.jpnprd01.prod.outlook.com (2603:1096:404:87::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Mon, 20 Dec
 2021 04:11:15 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 04:11:15 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     Mark Rutland <mark.rutland@arm.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>
Subject: RE: [PATCH] arm64: module: Use aarch64_insn_write when updating
 relocations later on
Thread-Topic: [PATCH] arm64: module: Use aarch64_insn_write when updating
 relocations later on
Thread-Index: AQHX0PbVbCaZeNwuSUmUD4agHX4R6qvzSR4AgEHA80A=
Date:   Mon, 20 Dec 2021 04:11:15 +0000
Message-ID: <TY2PR01MB525763CF6B5175A974AF612385779@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <20211103210709.31790-1-surajjs@amazon.com>
 <20211104121430.GA6534@lakrids.cambridge.arm.com>
In-Reply-To: <20211104121430.GA6534@lakrids.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=True;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-12-20T04:11:15.169Z;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0;MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
suggested_attachment_session_id: 4491c341-2afe-bb99-41df-6d408246d8b2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9bc2f7b-81fc-4f0a-7db6-08d9c36ec42f
x-ms-traffictypediagnostic: TYAPR01MB2991:EE_
x-microsoft-antispam-prvs: <TYAPR01MB2991C8B1DEA693E17BB31838857B9@TYAPR01MB2991.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tfRkTAOMQI1nH9u3m7K/h9e77wihk+1ucRuaUIHZmWWTg0RB7LP8acF+XPDdtYIvUsAkmCRmgme7XVJ/cswePVReT3D3Du6J7r6X0qPJOQTv71GP/Orbb2xyUQ4uQoJOytsiaI/8V4lH/45DvuRHny1dgBCaJWYcpU2pNtEiApi7trXMwsITVfS+NZOZEo2coA+aCkwEUDDCDMuSdMQ5BXv3QGjxqdgxfM5ubdxl3Y6mX4CxRz8t3PmFVkUlq0Bl/MXtsn5Of4WeTjPM01ZfX1KvwY61Jnh5bhg51RRB2LLC9TESSnL1gEoxd94mtEZQtzHKoN1wv8c4NufASMOE4HabnAfZz1gbR5hY3zUAtFehlEPp6oZxqglmaDzaNRvBzcrT8hQoaiX7Ja1TWAY1rCdhxtu7IcZKka7jP2biF0FqjC7UaA+6df/qrmDJgPzMZ2nIygCOHWki5RDrg7sMRbiBLKr1xoeCudU7tRvUvcbSqF2ac/bjM1mN4V7smpC/kHSXffQq/TfuxsJMsKwy3BQ5g9/9pk8nrKAqXRoBwJ4Dx7kiID4oQvMx7emACZuecaQqQXy9MvylYQJxSixCpQ8A+FhbZcm1xdBbVFamNirblfKWHHVE8kfucgKawn1wEsEKdGhkCjhRXDh7uaDHN0duGMJw6a+rPBFMFDbAWhwT9+964i9TgtxeId779y4aDLDy8biDpnEmLKXJDSCs8YxWw4pZFM4bVMhjlX5VoN+6DByJpuoTg/1XRnfaoi5CS355paWmuY+4exKWyOLy6cxiH7kF0MyxPyQM4kCsYTw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(33656002)(38100700002)(122000001)(85182001)(38070700005)(86362001)(55016003)(76116006)(83380400001)(66476007)(66556008)(64756008)(66946007)(66446008)(316002)(966005)(508600001)(9686003)(6506007)(26005)(186003)(4326008)(52536014)(71200400001)(8676002)(8936002)(5660300002)(110136005)(2906002)(54906003)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?ZmE4VHRQclNpSVJva3hLTzJiVDZlY2oyT3lTY1ZVMS9QWXlqQzBNZUU1?=
 =?iso-2022-jp?B?Nmt5NVJpUXNla1Q4OHprNTRYYnhLVGVpTWRva2tjUDRXdE9BUjYyaWJG?=
 =?iso-2022-jp?B?b0xCMGFrTjNtYmx4a25CWC93V3NweUFmbUNPNytwYldsQVg3ajg2bWZ5?=
 =?iso-2022-jp?B?ZzJzbEYxc0dEVmhmZVpmZ1lSR3pCZTFOUjBKUWl4MXprTXVDZUdqOXNQ?=
 =?iso-2022-jp?B?TTh3NzBmSkF6K3VCbThEWmYyb2ZnVm9XZEN6T0FSQ1JZWFpnOTFSeVk4?=
 =?iso-2022-jp?B?T0NNOThXVkw2Z1pJRExBWnlWSmhESGU1bk5NcEZidTVFYTA1WjlwZEFT?=
 =?iso-2022-jp?B?V3E5SXlnVTVYenZzOXp1SUFGUTRyQWtQVHZMcVZyQ0NDUTlZYm1jcDls?=
 =?iso-2022-jp?B?bkxRQjZDVUJnNWVEcU8rRjB1aVh0RlZuRzFPSWVUeHcyMzdtSWI1cklB?=
 =?iso-2022-jp?B?UzBlaTVST2ZHL01DdXdnM0p5VE9wTjdjZzVnYTVnYXBOZUJscWdWQkNF?=
 =?iso-2022-jp?B?M0xuL3FiK2ZlZmR3SThBa3loa0M4eEJRVEJqTDhFM3QrNTJLVkFTbGdo?=
 =?iso-2022-jp?B?ZktkczV5Umg5RUUrNDIvVEhDeGNWOXJYb1hUd1E3TkJTVUdGL1RMUzlV?=
 =?iso-2022-jp?B?SWVtR3lPSkZhZWYya2wwTUdWTkFZQ2ptRjhlRkR2dFA2a05TODJsUTN5?=
 =?iso-2022-jp?B?SmpraC94Uks3NVFIb1ZqK3lReDFWQU1nZUxrVDZabGNSZmNTbjZOTXNm?=
 =?iso-2022-jp?B?Qi9PajRvOE1GRCtid2JMTmR1cVlZUUh3L0NoaSt1UUEweE5SNmVjMzYw?=
 =?iso-2022-jp?B?aWJzUElxSUFEK1FiY3dzWDRvQkNIdlVZN0NUK2w3a0NyT3lYdDVXMXpL?=
 =?iso-2022-jp?B?ZCtodm1MQTI5YXNhODVaSWVHaVdhdGxzVmtkbzFYWXhpMDVMUHFzY1Vv?=
 =?iso-2022-jp?B?SkFFWlBkSXRmS1MyZVI3aVR0b2ZmQjJFMVUvUS9kS1hyVEJDZW1iWGxw?=
 =?iso-2022-jp?B?YzNKM0FXMnFwWkRnM1pKbjd6WEhYWjhqVkFkS01kdUdNMFNNSDdNZ1oz?=
 =?iso-2022-jp?B?S0RHNTR6ZTE1bFgvai9KZkhjNGRTSUdNdzEvcFlrUU8xcWI1NGpUcVht?=
 =?iso-2022-jp?B?SjRzT0dFc09mNkIyZXRCc01ZV1U2cDBWKzd4eTZ3S3ZWZXB4NlNyRHdV?=
 =?iso-2022-jp?B?Y2t5NFhTemp0MlBDTUd5RVN4NFhaNzU0MVFRM0Q1T0VTRlk2NzZEN0JF?=
 =?iso-2022-jp?B?T3Q5UnFOb1o2S1lUWDdpOW1seERLWVU4THQ3a1czY0J5N2lWUGU2Tkkr?=
 =?iso-2022-jp?B?VXR0UjRNTFJIYjgrWHYxZ2hWaVpGeTBPZ2dWN01RcHV1WmtBTldPNFhI?=
 =?iso-2022-jp?B?UE9ncjAvUTM3QThZODJZbDlHd2FYZmhGU2RzYVRQK1pOaDZSUTdJa09v?=
 =?iso-2022-jp?B?RzB0RGZYUWFQbkd3bkkwam1FRlk5N0NJVy9obitOZzF1cEoyMENubm1v?=
 =?iso-2022-jp?B?UURPa0UzMTZremQzQ3c4UGpZUW12TE1RVUJvYy9vMTQrS0QzTnNDcU8z?=
 =?iso-2022-jp?B?R0hvdFVqeGJuZTFTZlh0d2NNYnA5a1o5RnVZWDUrWHlhZERrZXRMS2th?=
 =?iso-2022-jp?B?ajZZUldxVkFQZ3JhUVFPQ1ZlektOK2w0Ym9BQTJqQ2dXdlRUTGoxNzNm?=
 =?iso-2022-jp?B?cUtCN0NxMWdGMFVWOWlOcUw2V0w4bTNqTWowNU9mdFkzLzNYQ0MwL0tx?=
 =?iso-2022-jp?B?S085cFdnQko1TjdQamc1YWpuSHpZbHlpTXNGd1NJV1hDZGVHbHdCZUhi?=
 =?iso-2022-jp?B?UFdrM3JaVkQzNUREZnVWckx6V3BaVUV4YkVGSDAvM2RkckltWWxBN0E1?=
 =?iso-2022-jp?B?RmVpZEk0eHdnZnM2cUtQc0N5L3dRQnc5WEhxcEZUamw2czlDMWczSGY5?=
 =?iso-2022-jp?B?SEc2YSsrNFoyaFdrTVRXSWpxbzdUK2xacDRJOXFHazAreTZibUpVZnBT?=
 =?iso-2022-jp?B?dHcyUkt5UHpyb0haaFNiSmpTN200bGZneUMydWlKQXh0dEpielF5bERH?=
 =?iso-2022-jp?B?SW1YYm0rU0N6cTZvQTVPdW03WWxKK3FQRVF5K0pRc1JJYWZieGNSV0ow?=
 =?iso-2022-jp?B?ZCtIS21OU245Y2FOS0hpUEMxYWthTVNuM2Q3OHdLajBRR1U2QVI4aEpj?=
 =?iso-2022-jp?B?ODNjU3ljOFkvUGRMdDh2UXdCZzVDbUcvV0ZIcmZWM3BRek9xU2Z5S1lU?=
 =?iso-2022-jp?B?UGlKT0tsOEtJZWhUa3hiMVEwNmtheG95NWo5a3drUUV5NVE1djVveFl1?=
 =?iso-2022-jp?B?ZHQ2ZkRacDhWSW9KWDNzS090QXhoc0lzU0lpaU5mTzVpT3o2Y1pRR2VL?=
 =?iso-2022-jp?B?L2Z0eFFuY1A3WVZZYUUvUm5NbkpuOEh6Vm1YTy95WnN4RE9pSXU0V0Vm?=
 =?iso-2022-jp?B?bzkyVGx3PT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9bc2f7b-81fc-4f0a-7db6-08d9c36ec42f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Dec 2021 04:11:15.4432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mod9T2Gv2Eoqxc8vOtn7Y2nSOB3/6qTOTSl5dBCJwkyYSdojIPWscfkWkEpULWQ7f3B7rMlnBIshJW+3/GPLOBsbWaJvSOJuagaQlZdmVVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2991
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi, =0A=
=0A=
> > Avoid this fault by calling aarch64_insn_write() to update the instruct=
ion=0A=
> > if the module text has already been marked read-only. Preserve the curr=
ent=0A=
> > behaviour if called before this has been done.=0A=
> >=0A=
> > Signed-off-by: Suraj Jitindar Singh <surajjs@amazon.com>=0A=
> > ---=0A=
> >  arch/arm64/kernel/module.c | 81 ++++++++++++++++++++++----------------=
=0A=
> >  1 file changed, 47 insertions(+), 34 deletions(-)=0A=
> >=0A=
> > diff --git a/arch/arm64/kernel/module.c b/arch/arm64/kernel/module.c=0A=
> > index b5ec010c481f..35596ea870ab 100644=0A=
> > --- a/arch/arm64/kernel/module.c=0A=
> > +++ b/arch/arm64/kernel/module.c=0A=
> > @@ -19,6 +19,7 @@=0A=
> >  #include <asm/alternative.h>=0A=
> >  #include <asm/insn.h>=0A=
> >  #include <asm/sections.h>=0A=
> > +#include <asm/patching.h>=0A=
> >=0A=
> >  void *module_alloc(unsigned long size)=0A=
> >  {=0A=
> > @@ -155,7 +156,8 @@ enum aarch64_insn_movw_imm_type {=0A=
> >  };=0A=
> >=0A=
> >  static int reloc_insn_movw(enum aarch64_reloc_op op, __le32 *place, u6=
4 val,=0A=
> > -			   int lsb, enum aarch64_insn_movw_imm_type imm_type)=0A=
> > +			   int lsb, enum aarch64_insn_movw_imm_type imm_type,=0A=
> > +			   bool early)=0A=
> >  {=0A=
> >  	u64 imm;=0A=
> >  	s64 sval;=0A=
> > @@ -187,7 +189,10 @@ static int reloc_insn_movw(enum aarch64_reloc_op o=
p, __le32 *place, u64 val,=0A=
> >=0A=
> >  	/* Update the instruction with the new encoding. */=0A=
> >  	insn =3D aarch64_insn_encode_immediate(AARCH64_INSN_IMM_16, insn, imm=
);=0A=
> > -	*place =3D cpu_to_le32(insn);=0A=
> > +	if (early)=0A=
> > +		*place =3D cpu_to_le32(insn);=0A=
> > +	else=0A=
> > +		aarch64_insn_write(place, insn);=0A=
> =0A=
> If we really need this, I think it'd be better to refactor the=0A=
> reloc_insn_*() helpers to generate the new encoding into a temporary=0A=
> buffer, and make it the caller's responsibiltiy to then perform the=0A=
> write to the real location in the module.=0A=
> =0A=
> That way we only have to handle the "early" distinction in one place=0A=
> rather than spreading it out.=0A=
> =0A=
> I see you haven't altered the reloc_data() function -- does livepatch=0A=
> never result in data relocations?=0A=
> =0A=
> Thanks,=0A=
> Mark.=0A=
> =0A=
=0A=
Livepatch can also result in data relocation.=0A=
=0A=
So I wrote data relocation test with kpatch and send pull-request [1].=0A=
Suraj, please try it if you would like.=0A=
=0A=
[1] https://github.com/dynup/kpatch/pull/1244=0A=
=0A=
Thanks,=0A=
Keiya=0A=
=0A=
> >=0A=
> >  	if (imm > U16_MAX)=0A=
> >  		return -ERANGE;=0A=
> > @@ -196,7 +201,8 @@ static int reloc_insn_movw(enum aarch64_reloc_op op=
, __le32 *place, u64 val,=0A=
> >  }=0A=
> >=0A=
> >  static int reloc_insn_imm(enum aarch64_reloc_op op, __le32 *place, u64=
 val,=0A=
> > -			  int lsb, int len, enum aarch64_insn_imm_type imm_type)=0A=
> > +			  int lsb, int len, enum aarch64_insn_imm_type imm_type,=0A=
> > +			  bool early)=0A=
> >  {=0A=
> >  	u64 imm, imm_mask;=0A=
> >  	s64 sval;=0A=
> > @@ -212,7 +218,10 @@ static int reloc_insn_imm(enum aarch64_reloc_op op=
, __le32 *place, u64 val,=0A=
> >=0A=
> >  	/* Update the instruction's immediate field. */=0A=
> >  	insn =3D aarch64_insn_encode_immediate(imm_type, insn, imm);=0A=
> > -	*place =3D cpu_to_le32(insn);=0A=
> > +	if (early)=0A=
> > +		*place =3D cpu_to_le32(insn);=0A=
> > +	else=0A=
> > +		aarch64_insn_write(place, insn);=0A=
> >=0A=
> >  	/*=0A=
> >  	 * Extract the upper value bits (including the sign bit) and=0A=
> > @@ -231,17 +240,17 @@ static int reloc_insn_imm(enum aarch64_reloc_op o=
p, __le32 *place, u64 val,=0A=
> >  }=0A=
> >=0A=
> >  static int reloc_insn_adrp(struct module *mod, Elf64_Shdr *sechdrs,=0A=
> > -			   __le32 *place, u64 val)=0A=
> > +			   __le32 *place, u64 val, bool early)=0A=
> >  {=0A=
> >  	u32 insn;=0A=
> >=0A=
> >  	if (!is_forbidden_offset_for_adrp(place))=0A=
> >  		return reloc_insn_imm(RELOC_OP_PAGE, place, val, 12, 21,=0A=
> > -				      AARCH64_INSN_IMM_ADR);=0A=
> > +				      AARCH64_INSN_IMM_ADR, early);=0A=
> >=0A=
> >  	/* patch ADRP to ADR if it is in range */=0A=
> >  	if (!reloc_insn_imm(RELOC_OP_PREL, place, val & ~0xfff, 0, 21,=0A=
> > -			    AARCH64_INSN_IMM_ADR)) {=0A=
> > +			    AARCH64_INSN_IMM_ADR, early)) {=0A=
> >  		insn =3D le32_to_cpu(*place);=0A=
> >  		insn &=3D ~BIT(31);=0A=
> >  	} else {=0A=
> > @@ -253,7 +262,10 @@ static int reloc_insn_adrp(struct module *mod, Elf=
64_Shdr *sechdrs,=0A=
> >  						   AARCH64_INSN_BRANCH_NOLINK);=0A=
> >  	}=0A=
> >=0A=
> > -	*place =3D cpu_to_le32(insn);=0A=
> > +	if (early)=0A=
> > +		*place =3D cpu_to_le32(insn);=0A=
> > +	else=0A=
> > +		aarch64_insn_write(place, insn);=0A=
> >  	return 0;=0A=
> >  }=0A=
> >=0A=
> > @@ -270,6 +282,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,=0A=
> >  	void *loc;=0A=
> >  	u64 val;=0A=
> >  	Elf64_Rela *rel =3D (void *)sechdrs[relsec].sh_addr;=0A=
> > +	bool early =3D me->state =3D=3D MODULE_STATE_UNFORMED;=0A=
> >=0A=
> >  	for (i =3D 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {=0A=
> >  		/* loc corresponds to P in the AArch64 ELF document. */=0A=
> > @@ -322,88 +335,88 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,=0A=
> >  			fallthrough;=0A=
> >  		case R_AARCH64_MOVW_UABS_G0:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_UABS_G1_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			fallthrough;=0A=
> >  		case R_AARCH64_MOVW_UABS_G1:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_UABS_G2_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			fallthrough;=0A=
> >  		case R_AARCH64_MOVW_UABS_G2:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_UABS_G3:=0A=
> >  			/* We're using the top bits so we can't overflow. */=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 48,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_SABS_G0:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 0,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_SABS_G1:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 16,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_SABS_G2:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_ABS, loc, val, 32,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G0_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G0:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 0,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G1_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G1:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 16,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G2_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,=0A=
> > -					      AARCH64_INSN_IMM_MOVKZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVKZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G2:=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 32,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_MOVW_PREL_G3:=0A=
> >  			/* We're using the top bits so we can't overflow. */=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_movw(RELOC_OP_PREL, loc, val, 48,=0A=
> > -					      AARCH64_INSN_IMM_MOVNZ);=0A=
> > +					      AARCH64_INSN_IMM_MOVNZ, early);=0A=
> >  			break;=0A=
> >=0A=
> >  		/* Immediate instruction relocations. */=0A=
> >  		case R_AARCH64_LD_PREL_LO19:=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,=0A=
> > -					     AARCH64_INSN_IMM_19);=0A=
> > +					     AARCH64_INSN_IMM_19, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_ADR_PREL_LO21:=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 0, 21,=0A=
> > -					     AARCH64_INSN_IMM_ADR);=0A=
> > +					     AARCH64_INSN_IMM_ADR, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_ADR_PREL_PG_HI21_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			fallthrough;=0A=
> >  		case R_AARCH64_ADR_PREL_PG_HI21:=0A=
> > -			ovf =3D reloc_insn_adrp(me, sechdrs, loc, val);=0A=
> > +			ovf =3D reloc_insn_adrp(me, sechdrs, loc, val, early);=0A=
> >  			if (ovf && ovf !=3D -ERANGE)=0A=
> >  				return ovf;=0A=
> >  			break;=0A=
> > @@ -411,40 +424,40 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,=0A=
> >  		case R_AARCH64_LDST8_ABS_LO12_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_ABS, loc, val, 0, 12,=0A=
> > -					     AARCH64_INSN_IMM_12);=0A=
> > +					     AARCH64_INSN_IMM_12, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_LDST16_ABS_LO12_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_ABS, loc, val, 1, 11,=0A=
> > -					     AARCH64_INSN_IMM_12);=0A=
> > +					     AARCH64_INSN_IMM_12, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_LDST32_ABS_LO12_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_ABS, loc, val, 2, 10,=0A=
> > -					     AARCH64_INSN_IMM_12);=0A=
> > +					     AARCH64_INSN_IMM_12, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_LDST64_ABS_LO12_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_ABS, loc, val, 3, 9,=0A=
> > -					     AARCH64_INSN_IMM_12);=0A=
> > +					     AARCH64_INSN_IMM_12, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_LDST128_ABS_LO12_NC:=0A=
> >  			overflow_check =3D false;=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_ABS, loc, val, 4, 8,=0A=
> > -					     AARCH64_INSN_IMM_12);=0A=
> > +					     AARCH64_INSN_IMM_12, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_TSTBR14:=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 14,=0A=
> > -					     AARCH64_INSN_IMM_14);=0A=
> > +					     AARCH64_INSN_IMM_14, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_CONDBR19:=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 19,=0A=
> > -					     AARCH64_INSN_IMM_19);=0A=
> > +					     AARCH64_INSN_IMM_19, early);=0A=
> >  			break;=0A=
> >  		case R_AARCH64_JUMP26:=0A=
> >  		case R_AARCH64_CALL26:=0A=
> >  			ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 2, 26,=0A=
> > -					     AARCH64_INSN_IMM_26);=0A=
> > +					     AARCH64_INSN_IMM_26, early);=0A=
> >=0A=
> >  			if (IS_ENABLED(CONFIG_ARM64_MODULE_PLTS) &&=0A=
> >  			    ovf =3D=3D -ERANGE) {=0A=
> > @@ -452,7 +465,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,=0A=
> >  				if (!val)=0A=
> >  					return -ENOEXEC;=0A=
> >  				ovf =3D reloc_insn_imm(RELOC_OP_PREL, loc, val, 2,=0A=
> > -						     26, AARCH64_INSN_IMM_26);=0A=
> > +						     26, AARCH64_INSN_IMM_26, early);=0A=
> >  			}=0A=
> >  			break;=0A=
> >=0A=
> > --=0A=
> > 2.17.1=0A=
> >=0A=
