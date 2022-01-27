Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F4749D76E
	for <lists+live-patching@lfdr.de>; Thu, 27 Jan 2022 02:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234344AbiA0BUx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jan 2022 20:20:53 -0500
Received: from esa8.fujitsucc.c3s2.iphmx.com ([68.232.159.88]:23992 "EHLO
        esa8.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234379AbiA0BUx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jan 2022 20:20:53 -0500
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Jan 2022 20:20:52 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1643246453; x=1674782453;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Fv9LqLwCp43iUePdiQyh5Hw8d1MrP7/Xngcq2NEq/Uk=;
  b=NRULSL08N9UgX74uBI3Qedk5sF9ypFrCoZxpibyR4O8WLc4AYnk2S+Rn
   y79SbG6+2mF/SxtLtBxaIkeq5wMwtYnhYH5FdIdGWVTm6fMUN20hRD96R
   l05T+MNJhu+7T6rrXm8Z2Sr6RRJi53tAvQNtN+Eac7JHK4WoI3Gu+An1U
   eBO9RTnB6EHx194wLSg9Zgeq++oqz3W/Ksks9/eV2D6CUKrnllYFn5/Zb
   mgBf7mm/WjJwROGbe+Cp4d1g4Omf9YW8YMcz51XCPfSW0iLLUmukxg8Wf
   TnSJXI0kBpRLubTNeNMZ5GONVHtvSZK5WbS+XBXiLaT/dci8R862ABA/v
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="48431845"
X-IronPort-AV: E=Sophos;i="5.88,319,1635174000"; 
   d="scan'208";a="48431845"
Received: from mail-tycjpn01lp2175.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.175])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 10:13:41 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVrM9rdT6PQoaru9yqvxsHbEJ/SIOPRkWM2hAMQP67jZC6EeYqy03ZJs7mocQpPsD8tHMHGZ1U0E1Oz/KkIBFpXOiMpA7GVYYiy+73jv5x+fmoEr1zBdfqHU3S0vIer1Lv9XPmfpkdG8IMsvcUU2W0c3bw72wSyRqBAqzRclv8q+yhP2dSyULQHpuopHksrfqV4/0zhim899FGwCvzORrec1g7FIH0dZrkUYCGEghjCNrr6LRKz9lmNPYEcb3Os98GP+rbirwIvpNnL6SX2QdMmExQJxrxB+4+gHaCFPNLBDVpueJbCjznf4L5kUvaPbui2Mqf6cXZBLmKZw496L9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fv9LqLwCp43iUePdiQyh5Hw8d1MrP7/Xngcq2NEq/Uk=;
 b=Ga8HprMDKwIJPe1GGCf6856ix13KpPhYL3naq8EN8AO4oBHsn+TjVsW48lBg8hs0Ob55/X+g8Ojnfp6dhvo8wGM4SNqvnWT4dPeHgrZy3QF8enPIm4EJMMQIk0j22fq/bNoLala9ZNcTIcyilR6ywvErEtscOU+Jd945/An1tqkplLSzp4ZG/qXg8MKudLVXHhy8P/yzGP6WMMjzw0/lY8ySwK+CGn8wxoGB4A8dpsPcXcsWgjxAmRhBeoM5z26x/4/e2SgYEVyYa1/AM7pzoz5J0rYWqLMgg8kSwhcObSPG9uwrJdKYd8Wwj4JO4eYxrmzuYWpHNF8x+YkqMSeVeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fv9LqLwCp43iUePdiQyh5Hw8d1MrP7/Xngcq2NEq/Uk=;
 b=YIXRb7EumBXMCgd4vxNj7/cbKTs5I+f5IO31/MGzhvhfOo/uKYX77CjannkS6gEo21CGqZ+P8yDvbpfnVimm7IPm8fkcFPJ8RxxQy6PXJ5maaXRUcsNc06RT+SfA3ltgl+6KIQdX5fL8HioCeB+QEjiDrVBInpE1bMpi/7aABaA=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TY2PR01MB5017.jpnprd01.prod.outlook.com (2603:1096:404:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Thu, 27 Jan
 2022 01:13:37 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207%4]) with mapi id 15.20.4930.017; Thu, 27 Jan 2022
 01:13:37 +0000
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
Thread-Index: AQHYC7J0j/1dz1/1vkuQ8Ct1CeQ76axzKz3QgACgioCAAPRucIAA2KoAgAB0tRA=
Date:   Thu, 27 Jan 2022 01:13:37 +0000
Message-ID: <TY2PR01MB5257F92BDD5E55914A63DD2C85219@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
 <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
 <825b8b72-c746-ba24-7142-3fff481e82d6@linux.microsoft.com>
 <TY2PR01MB5257BE671A481D81F1A40E0185209@TY2PR01MB5257.jpnprd01.prod.outlook.com>
 <1a0e19db-a7f8-4c8e-0163-398fcd364d54@linux.microsoft.com>
In-Reply-To: <1a0e19db-a7f8-4c8e-0163-398fcd364d54@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2022-01-27T00:11:55Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=f946a7f6-f72b-4807-b698-d9ae25af0fa0;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 520bb1dd-f8a4-4bc2-e492-08d9e1323f2d
x-ms-traffictypediagnostic: TY2PR01MB5017:EE_
x-microsoft-antispam-prvs: <TY2PR01MB5017743B6BF0DA38CCA38D2685219@TY2PR01MB5017.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KmCR+bWo90kVbCDooSB/jKnyE6zD3LwOaslxVUeAEnveRxoSv/foXxhG+2p8FlZjBRoXiUrbzX/J4Ja7TlMOEEKZCGXNg0bqixZd/u9cA8iDG20i8ow4sE+3Kph0M+P5GQzGcf7chdslmTIfWbRuvXUdz2a1/17tyJLx829GTC/DKw8YDkMbYdSqXopteELAkzt+TCp/hVmPHp8u+gMr/1QYcMEo8RhaG/hu6mWYNeuQQK0I/c7fC8VInDdibCGU6M6LMDdmhZ1z4QEUUFk/zjGrRydE9AGbBlwhe5MN/BpmBYNkhkKVHpL1qR72DLx8S2Jof6agU78u3D//mDTqLi0cfHmyAZWG9SpEaams2FilVQcrID15KR8uXSnTahJhQAFQ6+6A+a4kQ+5ApVS9WvHIaNxHzYYi3qEATabCBSo60fMbRttuKl5bmnw9ckcBI1e5KwB7jjYzab3ej++fsueETpKy9Ne76uMB42lwLuwgV+yMcPx5G7nWFiGta/RdEacfAOSC2itP808v9pWeLjn4egdw5FqFmezBgrMEAS6Lgj4Zi0G9n+KRS6+ElugKbJpBHZiSwE6KuNwb5nVXQl+WAXWAkQkAx8JxcSybl07yHBI4r12A+rBSBZKi114IYph7HvqhF2JAYiM1/nQ1b+sF0dykMAzh5iCt35/9YejMY2/g4OzuMFp6Fdjr2Wd6ga+vqUm5zS+uVPaVcVSHQoMhBPqO6N9DMrhFS7cA2qM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(45080400002)(38070700005)(9686003)(82960400001)(76116006)(85182001)(316002)(52536014)(508600001)(7696005)(86362001)(921005)(55016003)(83380400001)(110136005)(33656002)(6506007)(186003)(8676002)(71200400001)(38100700002)(8936002)(7416002)(64756008)(66446008)(66476007)(66556008)(66946007)(122000001)(26005)(5660300002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?SGo3MlJSN0lWcm9YOEE2RldPUTc3RTVxa1g5TTNvdjEyY1J1Y2dCSVl1?=
 =?iso-2022-jp?B?MXV1V1BuNWpSRWVPRUtacjR1Wk9ybnRBbjBRRTByNEo4MlJ0UWExWTBn?=
 =?iso-2022-jp?B?TGoxNVk1VDRkNVdNa005WjI0d2ErZFZIV3prNGUzd1lJUTRBQjlTaU1M?=
 =?iso-2022-jp?B?NlNBSU5CUzc1M21FS1pDbnRPSUxza3E1SW10emNLQjJxVE5PemZXWVVn?=
 =?iso-2022-jp?B?eHMvUllvWS9aRkJabWRqbHBySmJVb1NEdk5ONzg3K0xEUE5ReDAwS2Jp?=
 =?iso-2022-jp?B?WmRwOVQ0R1doRWhsMEYraWl4M082VHdOeVpyRVh0N1lkT3ptMlhUbW9B?=
 =?iso-2022-jp?B?RStBTDZCazJhK0llMVAzaDVZNmZwZUNMbng4MklucWVPUGZYUHhOSFps?=
 =?iso-2022-jp?B?Q0VuYlBhRVY0c1E2bFZLaW1adDBVd2NLbVprcDl5azN6by9ac1V2L28z?=
 =?iso-2022-jp?B?MG4zcFM5amtRSy9hS29wNjJXT01MRVV6UlVDZzkvOE1sbU52VW5mdkhl?=
 =?iso-2022-jp?B?TTNBYmd5S0Q5NXN2aXBMdURqVjFKNmIvN2V6Y0ppNzNjWmZDUjBsNUdz?=
 =?iso-2022-jp?B?NE9nZUhuR3ZxOXFrNmhzMUdPZjJ5cGw0bVU2MnBkWkpMYjdZdGZxdnpp?=
 =?iso-2022-jp?B?MWthZnBvcnUyUnB4aERaZHg0YUxYSUVuK3RuR3o4dE1rWlV6alR6amZU?=
 =?iso-2022-jp?B?STAvVThFTHR2aXBJbkRJU3dxcm9yeHRWRk5Vbkw4OVNCd011SEJnZTk4?=
 =?iso-2022-jp?B?UFFMa3F2eUV4WWE4aUxCT2JqcE1UY0ZORlQydUVsazZlREpRYVptQXln?=
 =?iso-2022-jp?B?QVJuUStUOVd2dzdwRmE4M1k5QjNYNzBVanlGeTdBUnplaGRCMXViZzhr?=
 =?iso-2022-jp?B?U1NKSkY3YW1qWTlGZmZ1UjVpcS96WWwzeVd6eGVjbVU2bk5uV1FDdUtq?=
 =?iso-2022-jp?B?c2J0NDhxSmI3OGRlVEVIMSt1Y2JjVnJPMjEwQVo0dGN6a2I1Q24yM1VE?=
 =?iso-2022-jp?B?dHAxa0cwdUVSZE5ITElHOHIyUnlqMEs2NXkxMktndzArL3ZmQUxhUmpj?=
 =?iso-2022-jp?B?dTE0R3hNYWNXZS8wNlhoUk5CRm1sYlBxbUtuK3B2Q1BMU2c4NGtONlJH?=
 =?iso-2022-jp?B?Y3BIR09UMW5oS0Q5NHlOOGV6VVZ5KzN1c2J0RHo4cWg2bUdCZExzdk11?=
 =?iso-2022-jp?B?cDA2Y3A0ZHZyNXhqVUIrNzFqU1o4dnU0UnZzT3h3cVpjWTZIVUJyWDVw?=
 =?iso-2022-jp?B?WmFQQWlESlhxTGQxSE1zMDRLamRKdWduREtrK2RWY1N3MU9WQkhvUmxp?=
 =?iso-2022-jp?B?aVhaYWM2YlFMdTFROVBiaGtwZzlMcXkyOTdRRXhVdDBaNnBLVC9SUVRy?=
 =?iso-2022-jp?B?K2RjRGxDU2RXd005ZXlmL01aVFkwWU9tUUQrNENiVzZnd1U5RHNIYjBL?=
 =?iso-2022-jp?B?T3lMd0lsNjNiTTd0Yjhkd3BheFFOdXhyTzJ1ZUJYdkp5OGFPUSt2anFS?=
 =?iso-2022-jp?B?Y0RUV0dQSW56V21BdWR1dXNuR3RGTnVxZmJuTzFRTjVtYVg4aGxoSEJL?=
 =?iso-2022-jp?B?QkxXbGxINmQrMHV6TUIwKzFNMUtnN2xmY1hFZDhiYjBhVTl4TkxJZUF6?=
 =?iso-2022-jp?B?Wk1YcEh1TS9zNjZ3b3h5enJ3M1h5cVZkV2N3SUFxaDA1aVBiSy9Vc0ZU?=
 =?iso-2022-jp?B?M25BMGhmS0J0NTJjUEt1UitTYURXeUtTZk9iR0gzNkZqWDdESVFqcCt3?=
 =?iso-2022-jp?B?UE0vV043N2YzOHl0TjlWUmFncUFpaFRqT1YxUCs1OWF3K3dIY1VrM0l3?=
 =?iso-2022-jp?B?b1dGUjd2ZzBPdUxINVVDajhTcFcvUTkvQkVZVlF1U3dEUEdBQm1yb2Mv?=
 =?iso-2022-jp?B?ZUpObUE0dWhJSGVILzU4SFloQ0hZM05RbTZnZGZDV3YzVXFKQ0oyRDU5?=
 =?iso-2022-jp?B?bHduSVRqWDYxcHBMNC9YTzhkcDJWRWlSakh4ZlhWdHFUY2luNUhCeGlm?=
 =?iso-2022-jp?B?RXZlQ2pxeERxM1BOUHhUQlFPYUFkRzBKekZVYkFXQlFUamFuZzhjYUpI?=
 =?iso-2022-jp?B?MjBRKzRaSDBaZUYxUG9PQlY1U0x3S29uQnZ4QmdBcEI5OStwanFRRnVj?=
 =?iso-2022-jp?B?djRPVkJnYzNRNjRrL3B0Y2h0aEdaeVpncms3Sk5BL25Zc1d4UGNPbW9u?=
 =?iso-2022-jp?B?Rk9QdElQYWNYMlRiVUtiWnkrZks1U1VRWldWc3l6VXpzSmVHL1lBY2pu?=
 =?iso-2022-jp?B?MTZaelNkV2N2MThxL0JOa1Uxd0h2ZjN4Mm82S09FRGpxY1NuZTRiUHdD?=
 =?iso-2022-jp?B?SForYWhDRFA1Tnk4eXRaOVFFbWRLK1Y2cVpKRDJ6dGRZQlRMampVazRn?=
 =?iso-2022-jp?B?M3QwZjhKUitNaTlyNVFhODdoNlRpaFc0Q1hYK2hDR3ZGWHFZV3RkQkd1?=
 =?iso-2022-jp?B?cFN2cm1nPT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520bb1dd-f8a4-4bc2-e492-08d9e1323f2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 01:13:37.3285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkLHOcevlxT5MQCH+L9i3eYh3/XsTsQTEqE6s6peJHlp6J6qcdfywny0RCiIC7PJVQ9KbsLLSPNcSVXD4OZxVaHau0l41Bz7X/abeDpXcJ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB5017
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> >> I have not seen any activity on that in a long time. IIRC, Julien quit=
 RedHat.
> >> I don't know if anyone else has taken over this work in RedHat.
> >>
> >> Sorry, I don't have any more information.
> >>
> >> Madhavan
> >
> > Thanks for your information.
> >
> > By the way, I'm considering test code for arch_stack_walk_reliable().
> > Specifically, I apply Suraj's patch to enable livepatch, and added a fu=
nction
> > that sleeps between SYM_CODE_START and SYM_CODE_END, then livepatch
> > checks if the task has an unreliable stack.
> > For now my internal test code working correctly, but my Kconfig exclude=
s
> > STACK_VALIDATION dependency.
> >
> > It seems that objtool will not be enabled yet, so I would like to test =
it easier.
> > If you are already testing with this patch, could you tell me how to do=
 it?
> >
> >
>=20
> For now, I have an instrumented kernel that directly invokes arch_stack_w=
alk_reliable()
> from various places in the kernel (interrupt handlers, exception handlers=
, ftrace entry,
> kprobe handler, etc). I also have a test driver to induce conditions like=
 null pointer
> dereference. I use this to test different cases where arch_stack_walk_rel=
iable() should
> return an error.

That's good to know, thanks.

>=20
> As for livepatch testing, I have enhanced objtool and the kernel so the f=
rame pointer can
> be validated dynamically rather than statically. I have tested various di=
fferent livepatch
> selftests successfully. I have also written my own livepatch tests to add=
 to the selftests.
> I am currently working on preparing an RFC patch series for review. Basic=
ally, this series
> implements STACK_VALIDATION in a different way.
>=20
> I plan to publish my work soon (hopefully Feb 2022). I was going to do in=
 December. However,
> my workload in Microsoft did not permit me to do that. I am also planning=
 to set up a github
> repo so people can try out my changes, if they are interested.
>=20
> So, stay tuned.
>=20
> Madhavan

I'm very interested, so I would to be happy if you could tell me when the g=
ithub repo is set up.


Thanks again,

Keiya
