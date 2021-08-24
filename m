Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08BB3F57D8
	for <lists+live-patching@lfdr.de>; Tue, 24 Aug 2021 08:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbhHXGDR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Aug 2021 02:03:17 -0400
Received: from esa11.fujitsucc.c3s2.iphmx.com ([216.71.156.121]:30382 "EHLO
        esa11.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234561AbhHXGDH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Aug 2021 02:03:07 -0400
X-Greylist: delayed 433 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2021 02:03:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1629784944; x=1661320944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XHnFCxD9sGQI57gqWHUQx0rOhdQHeWIF3rrOhXPfaNk=;
  b=FIMgOJH+lcc12iZA2ZMmD2ZpkAtZtr5+j3rtOI8XCR4uNCOfGLPbx41V
   BM8esgQk1iuPYsouDSOhUI/TlYPj3ni7D9Fu24IL4heKiu4SwxltTem53
   XVtZR44qyNpDbj4YFVVAgCBQrpV1VjJ84xBHcmGkaR5HHRLUgh14S6UZU
   Pe3Tucjm1LjOui8Q+mUmQ8cXIoezmvpnWKUs16oc02dYlOWxLFAZ13tyX
   hEFhfqzV9oGcp8NglgGiA/Io7dIYmxquv0Rjdm9L/EerIENFpXUU4NfqB
   o0S6o1DdQxXZecZMX/vfRpD7lpSrZlUESP+BksfDmF7CnuBB/PnCneQR7
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="37705242"
X-IronPort-AV: E=Sophos;i="5.84,346,1620658800"; 
   d="scan'208";a="37705242"
Received: from mail-hk2apc01lp2050.outbound.protection.outlook.com (HELO APC01-HK2-obe.outbound.protection.outlook.com) ([104.47.124.50])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 14:55:04 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNR1wY1HPzvRQmc+xqN+6sle9POfD4lV4iVvmxUaiOkRxc6JTCbcL4PyYmvSnkgnV78iv2hz11rFh/U8Xe3kiEP348FUr/MHrvxQobPtTYUAWkxenPAuH+Yf54KdpwU5/rw1XFKQmrrltfU87jy4KGuYX2GmC1aiTHOE5YM1p/M9hr/5rbl3uPL5cEKERvpIIcEBj0iApKQUmMka2vb+AwdSF1bD+xFbY3AtcoMNAlSQ87VqRtwUE/9BWOBQnLHFZ2ztxK7mvM/11Hx47iup8OT1blbXl3ggKN49OWQfrUnk+U5ceKTFkjq/yc+K9eK29gSpyVzOEq92Mj3Esm8a7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpFdOqqBQbD1sjKE9yWt3dKcoukbEcAf4SuUQrLykxs=;
 b=U9SfoPDJK7ciUZsF6/mJJxVCrqMNzD4UZbSOcM1bLJeIQr1+MMHXVu96RsP7Fl9Dry0c1m/shgadL2r25Ca0zy+HDG+/Tc87vM4lH20HgY1QLImNYFbI3Lhunm6c33zKqO5SmJnFg3GUEsvk7m4pSQL5WUhLZ8MZ0RKuJAhzSoPqWRE3n2vr2Gl6rhzzqyMPsn7UV2yoVKOYpoB+hMLmKbuGgrTqzR9BnIl2Wnr735iVFmlhQCaDsji0slIeeC3jbYq/4Q1P5ctuLitJ/f0r2dKMzwHYHHiPhsr7WzK3SHJpfe7iwkba5USQ2vy0xK32dV7ffq5q08kymONJ9wb8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BpFdOqqBQbD1sjKE9yWt3dKcoukbEcAf4SuUQrLykxs=;
 b=jjiLF7dp0S9cMxeCBrlwRkJlmyKSEHCoBvLWq3B9s6zdGH5J6K8fO94vniMv8p0DAzVtdJQZGbq4ue4O1XWY4a0uNGUbDCzq1HOH7udejP8r5ESPepTxlLD06m6r/UZjEaNXasQSjDFeqZvLXxcbuq4yxUtOP+UX/nDdFBEtXk4=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by TY2PR01MB3708.jpnprd01.prod.outlook.com (2603:1096:404:d7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 05:55:01 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::d0f9:bb55:deb4:88bf]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::d0f9:bb55:deb4:88bf%5]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 05:55:01 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>
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
Thread-Index: AQHXj60kVJNMm5FzxU6EDROYO/rEjquAuwsQ
Date:   Tue, 24 Aug 2021 05:55:01 +0000
Message-ID: <TY2PR01MB5257EA835C6F28ABF457EB0B85C59@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <b45aac2843f16ca759e065ea547ab0afff8c0f01>
 <20210812190603.25326-1-madvenka@linux.microsoft.com>
 <20210812190603.25326-4-madvenka@linux.microsoft.com>
In-Reply-To: <20210812190603.25326-4-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-shieldmailcheckermailid: 3dc78b55451e42498dbabcdd62646a2d
x-securitypolicycheck: OK by SHieldMailChecker v2.6.3
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2021-08-23T07:05:05Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=21f02167-eb38-482d-b14e-18e9e59d842c;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 325f08f5-5790-49cc-fab3-08d966c3b65e
x-ms-traffictypediagnostic: TY2PR01MB3708:
x-microsoft-antispam-prvs: <TY2PR01MB370843733C88227AD2EA3A3485C59@TY2PR01MB3708.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sfldlvqN3AJEGMaqSkMwZmuyjfCsddeiHAAa//s2xSy3PBVEY704Xk17E461jsaBfvVhKxUOq9K7kuyKD/wW+F4vThzntfB/qdFxdDNypHXtPj6riJZ/wyW4m1k9K+TbPwoshAa+yrQauynWHMxB4WxjMfPBvxhgqZtqg47bDUt8fjzF5AWRfSahFnCnEtTHBxPFh5/gKhGJyd4wcJfMe0EhZg+bzXh9lM+2NTPShiA3kL4Lk8i+K8wUpgwNGB0fP3j77QxfTJ2v+fthXLu03cJGNOnWpYngirmGCrYEWdM9c7/X/yf636dIKCAYxNxQNF30FlcwmdrQdKGMRtyQ7n22tePKYMXGXtCF4B3GHVplKPo2WAtvApf/mCo84/gj/Bzw4ErHG59UZ142Y/pmrlx18nHg7zVlwQIASH18fqiIa+5mzFghU1oEODZCCJa2wOhw5JbvRX1pQHr+QDcGZoTNfAWIOq+/iUsqURCT5tspvVebUu1JsqXUXRXBzKMX2yUv8bRFeSyfxPr6gt7/sVza3n+/vqPmrUhZX94SrwIuSl7RmfwGOAJx25qti9z1S8kQO16g3NXJ9q69S43vZ8DAoL8jYD4+M4iwBsyEy8KojiqVTeuyujkWT8EPyMC7lR+aBw/mq7SPWCdt5AVuSI3s6g6HyVykSZiQVaau8SRre1gO9HQB09WHqpHcVpQIl+J9c47xu4jCkdurXRb+b+0igh0nkhoq08VojJEnQFM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(5660300002)(9686003)(8936002)(8676002)(71200400001)(52536014)(76116006)(64756008)(66556008)(33656002)(66946007)(86362001)(66476007)(66446008)(478600001)(186003)(26005)(122000001)(38100700002)(2906002)(7696005)(4326008)(7416002)(316002)(6506007)(6916009)(85182001)(38070700005)(55016002)(54906003)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?bnVYRTM1SEVLSlF1WEtEWTcvSzJJYjNMTkt6WEhtak9ZWnNOaTFHbTVs?=
 =?iso-2022-jp?B?UmZ5RklXaEl0Rmo4MUFPaDNneFJ6M2l2UHplYnFBVkFrRVFVcFJ3cm1v?=
 =?iso-2022-jp?B?Q3ZSTUNMMzdESlFYYi9vMUlUZ0pJYU14Ui9mUE9OSm95V1JCdk1TZ0ZO?=
 =?iso-2022-jp?B?MWVFQkt6Q1BKMnA2UlNiOSs1eXROdDBydFJDVGl1QklHekk4OWxCMEVC?=
 =?iso-2022-jp?B?YXZSUlNvUzJuQVN3bXZOQ2YweE5oSXNWeDJQZENZUythTkdnTnF4NGtR?=
 =?iso-2022-jp?B?ZThiNzVmbm9EcGRPWU1UZ0JGVTFUb2s0SnJXQUxoaWM2RWJ0cDhZNUlo?=
 =?iso-2022-jp?B?bjQzRnJPZUcwYjcvQ0F3UDAyYmVSVTJQVzVZQWxMZncwY0pHZVQreFdK?=
 =?iso-2022-jp?B?Q25KUjM0a2RoY2w4bGpkWlNRRi9hM1playtEMU5WS1Z2WlJtd3ZRRmdy?=
 =?iso-2022-jp?B?dlRpU1ZVWGJlTlNUN0QvQ09HYlROMW5Zd0FZSy9UbWtyMHlLMDk1N3Ay?=
 =?iso-2022-jp?B?SVR6Qi9kZXdmck1udlZRZ2xLZW9zb2wrRXd3T0x0WDk4OVRZNmlFNEVU?=
 =?iso-2022-jp?B?VU5lZ1duR05yR3ozOTgrTmxzUXk0Zi93a3p4MlptdzM3MkRyU01uNjBw?=
 =?iso-2022-jp?B?cGsxSTBqTlBGSEorQkhPMmdFMXl3WTBrMU1IZHN5bjdKcU9qcmNsSWdZ?=
 =?iso-2022-jp?B?ZDdXY0VkVThOZEVMYnRSM25ndnhPN2x1WHptWFdMM25QcXhUTzBFT0VQ?=
 =?iso-2022-jp?B?RFhkcmhzMm5HWHNDY3dYVkdwdXJBZHdIL1Via0sxdEVvZFN5Z0ttNEhn?=
 =?iso-2022-jp?B?UGR3eFNqbkhPbXBKU293eGI5UE9xcVI2bHJta1VWZzVwRHA4eGtHUmRW?=
 =?iso-2022-jp?B?ZFZ1cEdXQzNwbm01MlVaSjBDQW92WXV2QnJkUlQveEt1WlBtcmsyc0Nu?=
 =?iso-2022-jp?B?SkwwazdhamxDRlNHOWhpRGs1N0N1d3pjVXUrUFMxMlhYMjQ1RWxtQVlJ?=
 =?iso-2022-jp?B?bUd3QmxOTXNuSndwcFJzYlM2Yml0RW5IM012VTFMdHBJenNadlRZb1VP?=
 =?iso-2022-jp?B?QmtqaFltT1Y5ekZlcS9Ea0JYdFpHdmV4MjhEcEE1T01tUkdCT2hZS2NF?=
 =?iso-2022-jp?B?cS93NkxTL1RBeFZmakFScGhvY1VSc29NQWZvcEJXclhjWjNuaWNDQTl4?=
 =?iso-2022-jp?B?cTBhU0llNUZ2VFFaOGVDSWNuZjRoSWRvaDRoaERhWmtQc3NJQVZHVHNY?=
 =?iso-2022-jp?B?N2VCRTcvTWZXQ3pneVRmK0QyWXRDZytLKzN6SXJScTZicGRHV2lJaVVT?=
 =?iso-2022-jp?B?Nm5lMWNjaVFna3kvMmJCRzdLVnA4VlU4TCtnMDdxY2VOM2txZEVEWWJB?=
 =?iso-2022-jp?B?QVJlV0p3UWVtekJ0bkQwNW9EclhhSmxyNzVHcDJYOUU5QWk3Um9jWWFO?=
 =?iso-2022-jp?B?dEtyWE1JM0ZoMk5BWVk1cVlnMG00TWpBVEtRQUJ6UTdkOEZtTXlxNHh3?=
 =?iso-2022-jp?B?Wm1rWlJXR240L0E5eHdkeXFuOW8yNnkvSkZocThzUUZVZkZTN3VNNGd6?=
 =?iso-2022-jp?B?Y0NrMjZYc2c2UlVkZVA5K0tKVUtTaFZxdlY1Q0R0LzBDY09Cek5leWJK?=
 =?iso-2022-jp?B?Wm1aZ1FEUEdwVjJBT0lqMW5Qc0U3TjFTTVVGNkZIekQyQldPdDRNQ05Z?=
 =?iso-2022-jp?B?MWtGZjRIS0FoRXdvYnFqakNORzMvbkpNWjNBUklFNzFDbFB4cit2VGFH?=
 =?iso-2022-jp?B?L3ZaVWM3OEc2M1RneHF1ZzNYQVJtZGx4TVBHNWNPdzRudndFbldrWnoz?=
 =?iso-2022-jp?B?Q2J1Ym9JWkJ0ejFuRVMzc01kTjZjR1gwSHhHM3k0UEQ5RG1xajNWVEFU?=
 =?iso-2022-jp?B?U2Rxd3ZoQ1lXQ0k4TDJLWGU4VDI2YXhzaDlNYUdTM3d6YVcyVUs2SWUw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 325f08f5-5790-49cc-fab3-08d966c3b65e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 05:55:01.2850
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lua0HnJAutO/EI6VTZaAccjL9zZ9R+NkUnTvatWlzmvG9a6Ipc1Fw9+0yKsYIi/Bs5egyFY7ZCBz7csS7oAWDHDftGFmMYftsKF1gLGNfqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3708
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

> @@ -245,7 +271,36 @@ noinline notrace void arch_stack_walk(stack_trace_co=
nsume_fn consume_entry,
>  		fp =3D thread_saved_fp(task);
>  		pc =3D thread_saved_pc(task);
>  	}
> -	unwind(consume_entry, cookie, task, fp, pc);
> +	unwind(consume_entry, cookie, task, fp, pc, false);
> +}
> +
> +/*
> + * arch_stack_walk_reliable() may not be used for livepatch until all of
> + * the reliability checks are in place in unwind_consume(). However,
> + * debug and test code can choose to use it even if all the checks are n=
ot
> + * in place.
> + */

I'm glad to see the long-awaited function :)

Does the above comment mean that this comment will be removed by
another patch series that about live patch enablement, instead of [PATCH 4/=
4]?

It seems to take time... But I start thinking about test code.

Thanks,
Keiya


> +noinline int notrace arch_stack_walk_reliable(stack_trace_consume_fn con=
sume_fn,
> +					      void *cookie,
> +					      struct task_struct *task)
> +{
> +	unsigned long fp, pc;
> +
> +	if (!task)
> +		task =3D current;
> +
> +	if (task =3D=3D current) {
> +		/* Skip arch_stack_walk_reliable() in the stack trace. */
> +		fp =3D (unsigned long)__builtin_frame_address(1);
> +		pc =3D (unsigned long)__builtin_return_address(0);
> +	} else {
> +		/* Caller guarantees that the task is not running. */
> +		fp =3D thread_saved_fp(task);
> +		pc =3D thread_saved_pc(task);
> +	}
> +	if (unwind(consume_fn, cookie, task, fp, pc, true))
> +		return 0;
> +	return -EINVAL;
>  }
>=20
>  #endif
> --
> 2.25.1
