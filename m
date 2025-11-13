Return-Path: <live-patching+bounces-1850-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4413EC5570E
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 03:32:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33B8F3AD24C
	for <lists+live-patching@lfdr.de>; Thu, 13 Nov 2025 02:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EEB82F9D83;
	Thu, 13 Nov 2025 02:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Z7WCJzd6"
X-Original-To: live-patching@vger.kernel.org
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazolkn19011014.outbound.protection.outlook.com [52.103.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECA02BD03;
	Thu, 13 Nov 2025 02:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.1.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763000948; cv=fail; b=dgQ83pWdjLueM/sW7HPkk1rH51nQKUoHwQrVy/V3cOWFLy4MNLVmo3zc443YFtjNUDaVtxAqOAsCkz4qt/PQRicxkBSAKDkCApeMaNtOyP4NtyV7xyGdlY4HlDHkbglAef2cWM7TGIFoD4V/PodXZpbsK44+7OPHdSyrk9uE1A8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763000948; c=relaxed/simple;
	bh=gna50sgETZdMWReh1AEHoWjCScpbaILyjIzB/vtm/Xo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W0xKAtLX45FLGKdULzfkyyXwKHMcZK1cRTFAKqk6faJXCm/PR6AGgu60pD5wIjWaOHECOAKslruP22O+O5j22Kje3ER6Qp8oZdqhvZmIpm1Cyc5y3Am4AFzEcD40kTYtVzU+dZ0rMFr5Ztnafmn360DvmLyK0+xHCHyCLpxiH1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Z7WCJzd6; arc=fail smtp.client-ip=52.103.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LzRp4HxZKTwFJcr7J5+l91crt5WcdIAI+B8vYCELbDuTSmDRqRLSqXlJMjuHBSZLLrJdBPG1F2+eDmPtiPq3ImS4Kd8AVLerohke7oJOR/4fd1xIhQalDdi+v0if+lXbls+A7RJKbJC83gdo17bZkIZRyEgwXrVccEcksS0LZLRFlhR8p+yfH3lYB8GyG/9zY4fdegA7mEaSxOozHEP1cRMzC3Ae4nw2Ee3wAaARTxuvhsZf/yAo7BRJIzaxsqD0BI20PynceuEU81a9P2F/03xeTOHUhBG22R8D6O49eQK28E23LKxOL6j+Edz5KdCcnjZD1eXdgfvqxp3MbF2tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/JwGJwPL1JnsOpTNIZLEvU8bah/9gbqA7BHI2CpUMt4=;
 b=E8Z+baJ5gC0Aab3Y2pSRbTPcBJUHJfnnOsK1RglDYCUgXU9q8n5hzlq2GQZuYIcn1M8WA7BzSFzC4iVLwGAHM/VuornM5toh5d0Rk0Wh4fHXQXXU+4lGTs7cTw9dqY+YScSNAcFzqUYQJ5TqUsL5QXmZb+btUUGzr254sr+fZX99uiM5g7ZLinoHMQHAtaK5Bh8L059ydfLkr19H1nSYjqINvbbhLxVS3GrZs8U1mMtZzyOvvmDTDFZd0ncdNsAeVnLCNlNs7DzolvNCwadOTOGVT37/eyFsYjOIT3N6WP1GcHQ7z4neJEf4g+81AAg3M6JqqWucKtV8Pw78K17btQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/JwGJwPL1JnsOpTNIZLEvU8bah/9gbqA7BHI2CpUMt4=;
 b=Z7WCJzd64ul5E+JBA2R9oJ+PXi7bD7Ka2vMZEIOWyciyDpkp3IYh6OkI2SiuZF1Pd2sdcrdF/+t+N1dk3cCdzsVawtjlNfZR7zTUzTACcqu2JMlfTnhZqfcbByJUJQEBHm3XO2/L0fQbXv1xc36T6PRVlcF/udhhaCB49gVp2tiKPLy6Zu6rOarYyVpvJV6CWI50cJeojpPrJx1Rzw7BU+z8eSGGxA6RnVr6v0kiL9Z98nYFj1Lyp3ETWfM7fYEH/V3vYweSEFJK7sGPJ6JMycvO9XY6JFkyVWsC6eAKG+HxezW0y3IfERONrPxa6RlW8x8/N9wiZ9SmX8Kcj8Meqw==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by MN6PR02MB10774.namprd02.prod.outlook.com (2603:10b6:208:4ff::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Thu, 13 Nov
 2025 02:29:04 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 02:29:04 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>
Subject: RE: [PATCH 2/2] objtool/klp: Only enable --checksum when needed
Thread-Topic: [PATCH 2/2] objtool/klp: Only enable --checksum when needed
Thread-Index: AQHcVCymve8yqyZLv02jzrfcJWphdLTv4TCQ
Date: Thu, 13 Nov 2025 02:29:04 +0000
Message-ID:
 <SN6PR02MB4157D1FD4F6AE2BEFE1E9DF5D4CDA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1762990139.git.jpoimboe@kernel.org>
 <edbb1ca215e4926e02edb493b68b9d6d063e902f.1762990139.git.jpoimboe@kernel.org>
In-Reply-To:
 <edbb1ca215e4926e02edb493b68b9d6d063e902f.1762990139.git.jpoimboe@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|MN6PR02MB10774:EE_
x-ms-office365-filtering-correlation-id: 2a6c3201-5364-433c-545e-08de225c69dd
x-ms-exchange-slblob-mailprops:
 5fu/r660v9MHSDx/iaeYuri4/Uqx8pWIpd0L9IQeKrr1lfsD/XWk2XLMOG7pfEYD2g7K5CyknjB8p3uGLIzMtqeTs9DQgHoShHxuKl0bgcyb9pbyiuJt/21/gjMXTEjYmiIlahoV6D/14DPDKlwgJZelUtG6UmTjmoRoQlhs0EIUVmIiSHJekGPqo+eUbG0ffXqKjzV3a1Lvnm07+LHxIqG4P3ZrE+3POL0JdgbuJgEo9cP0WewscalpJABR62fPMtyzxZ72ZCbhZc7qQCsuPIvIfggyaHH1ypkRpvtfNBARcKv93D0TABo7RUDI1S8aiH78XQZsNYRJBNOKKfqC9aYnaTW8DEp+1IZJo4MvVvuJ+XRIY+tLXfYa9viQ6PH6BgI9PKnEKicfrrWGz632yCA1ETUpZL2DS4piNzNYKucv7ok+/YKsu3hKb1zozTZT4jZ97MgH+6LSh916LXy/NhZcBcdfgZXZtPngQ3tFqlMny9vsjtqLT/4EXd+IKJDkmOCVApT6AXpBQmh9F2eL6GML712qhN1tM1KeRpUVTKSHnGeq2YuwXCCACaH/Buhpv1HpcYicK9EItwQTeuxPFxVNd3KEfmMa+ganVytG7e467dXFUz/LGCY4Q2hnHuC6BGqB3NKjeF9XItekiX3MKofFZPIqwTThX/AYAi1ITdy1OM0hmg+i3kryMPnVBd0vjpuGsB/AgThpYA7i75LVVeusJVrT2D8qGmykv7sdrC4=
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|31061999003|461199028|51005399006|41001999006|8062599012|19110799012|8060799015|13091999003|40105399003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?KPCaIdMW7hcBul7CU05hTkV+CGd5J6UCJuNa0g0ShEMEn3hX1Mc5j+rfHISP?=
 =?us-ascii?Q?A7KANud5Y+T7dqPK+e/6JkIz17/+9PCF5LFnkn0cfQSeXzKSHxk4Mh5PbiTk?=
 =?us-ascii?Q?Z+i16lfQn0HwhchnDqGrnIa4/Y0hft2YMN9GAXJAGSaalOymj1UiLoo7glBY?=
 =?us-ascii?Q?5t030Ds2bU9E9b5KdL+IvWUYfObQjnuGgTAXfRMTvkFchrL6NgHT4IqHOpLM?=
 =?us-ascii?Q?FeJKWjQ2RGfh4RZ2dCeaOHzSea4uBmGvogik+V5R3OaiJ4IhClfWK98c3Ab8?=
 =?us-ascii?Q?y+If4CRPUEePcZZSVNkAQtPj15ANSFYdqvilD0nsdrGACgLkr5II5qSvkHG0?=
 =?us-ascii?Q?xUpne9C4duUR8B48QQ3t1BEkTGpFbWn1UIVYQmO49QvDprkEN6qkMMhm86SS?=
 =?us-ascii?Q?ys88xW+EjiuJdzpeZiMuqQ4wrMMFiMgryYfJ2zNJqAAkqjr0bfA6qUFDM6Jx?=
 =?us-ascii?Q?KjZ6PcyMTjEMXhacUTtF4aaGl/Vi51rf/rGS5G3j3MLOPq/4T1A/OD5Xp5HY?=
 =?us-ascii?Q?uwn4fFKJLDXlHlY7xBHutA6YhnP574bmzSAuAPlh/k5u/rAewdnkFOlJH9kT?=
 =?us-ascii?Q?l01CGr7PH9bHV62bqXlmJJujQa/bIDELXrsDjRAEBB3p+TVcMRNZ6dKOsTQg?=
 =?us-ascii?Q?4wAgkoNMU8sjXI3IwsvqQD/JBlfS+n7kOmbDQsubMgci14AQQ0SlU9tW8XRp?=
 =?us-ascii?Q?q5paUa/Ag6XsXu5i5NjHwBS5ItvPjKipl4ZJlHcW4c8m/yF1aBI/R3CNjUv2?=
 =?us-ascii?Q?Z8fyTYBFUSR7o2SCLjUp23z5tBp9MWjjhHxJT1IxzcxMUtj/8YMcgJ30vJTw?=
 =?us-ascii?Q?RD2ILdMSFzgDZWoHigPir5T/fAgP7Y7e2FpdIXK2m13bB0Xbbi3yajoA7e+Q?=
 =?us-ascii?Q?RI2xGkxEbRG/wvG0HQL65zmrWMwCl9TdDEk9w5NjeNoch8uRg/YbnvSntjZd?=
 =?us-ascii?Q?KalbnATnyAQtiYDvDVHjoxDPb+npnJb+IB8QwKqJzR/WOxBF6I5Jcnv6n70I?=
 =?us-ascii?Q?YSmRjFGdN2p1zvFkDDvSfUjaDSInaJIAMlmbrJjd5Q/SjhA28mF35HbMnM6n?=
 =?us-ascii?Q?LefgrP7eTUEASvuVofnpVuDXIojHXZRFbEyMXF0+FWt4oVX5KJKfS0cmNfyS?=
 =?us-ascii?Q?qY1dN740cQbL3PFCZxqhoOcxo8LlXW1KhV2vOxJShnrTnfTVhrjGm0eI7gNn?=
 =?us-ascii?Q?bHHtzg/iqkuRd6S9xk55CdXlDEFcjdkdadLWqBM12EGQWuj7VcPB5VKUIdOl?=
 =?us-ascii?Q?arf4aZaETIOIBUZ3tyCk?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?ADxHubr2qmqUbelF3X/hu0bZtmJ+M6+1RRB2tjrTyeJ0d6nSWhUCJC2VCIkT?=
 =?us-ascii?Q?BUPcCe6gd8UNHin36WTcYaHJSQiJYT3QqKoU8coc2obNRecjq6sQd+wGZa3j?=
 =?us-ascii?Q?barN+6XtdEwVQWcPCwHiD2E1FSlgh7zATa4Jsa8OKOzhK9I0Ya2zadXotymZ?=
 =?us-ascii?Q?HubfzMd6UZ0w65T1x2u0Neq7kZItB7YGGWBvGbfPwfqyXY/ZaUKt9TsKTHJp?=
 =?us-ascii?Q?iHpfjHHSkr8EzTOP4wfolRG/AFkb3j0gBQu4hlwkw8Q2TYRGTVZctxDKp/Pd?=
 =?us-ascii?Q?p+PRaNAmh7ZreUNtutok3jsAXneM1TI3yRLT6Fz0gSWEJLYNJ+QJ6vcdnY7s?=
 =?us-ascii?Q?+iQ6RKO0vAhiWKAMsI9EoI2WT5D6riwv9ahgdfe96V+XxkVlRSE8v5opj1yb?=
 =?us-ascii?Q?OGdGdbJQX0m06TFp4f35yabtz+UJu9jTq0K0Ac7uTsf+yXINUBhH24MCv6pw?=
 =?us-ascii?Q?Wt82gGx3dXJFl43FKbO8xdiJjjTqcFoCBJ+HpGMt1n4tHYK2Ucz+GVkMihz8?=
 =?us-ascii?Q?mQyaexML+u892/HieR5Xd1KBk0c3B4W5v54nlMhcMMXSrJRdUBmPzjlW514E?=
 =?us-ascii?Q?pquNL9SBWOSAzKwa8RQIMF2b9MQqyGgEy7QeL2HhrdK4oHm+Z25pJJmWO8K8?=
 =?us-ascii?Q?VVW2w+8oloD1wekuuEpHVzHChsYbQnsJqLgG4AB0O3QlL9U1gKU5ncH4gXto?=
 =?us-ascii?Q?mFv5N6tYpqlBGS43yftZ67VS1IV0ccAdRtEfkJ9VYCLCnLQP4DRnQEwDkB7s?=
 =?us-ascii?Q?TGlUvjfBbJC4qJ2vB7TmpH3DN0GJqfsFZ0ARgNOGhyKnD3DVn5Mew/DPps/q?=
 =?us-ascii?Q?e5yrMr0a49WqMCooYObkLqWAaCRFIAc3kHDGGylkQX1beDX78nkIYZWh2tMP?=
 =?us-ascii?Q?3bLakwhTs/AVLGgVD5QtD+1aIkpqKj1JYdcqQ14JV8gXHlJoE1UxXk2HksAL?=
 =?us-ascii?Q?l8lIAWCOVsQootoD7nIs5c0M4o0/D/UW1Au/moQqp4fIBzT80qMqAG2fVYJO?=
 =?us-ascii?Q?rDibmX/L5cDuq9W2MxcDD8YXALA1xzbaRY9Bjn6zrvF1lQc8H1C4JVicCTFy?=
 =?us-ascii?Q?8J2kytdfgG1EWxvC8h/4Dl/x8mIQpxVb+bC6s3iWcrJ6oFJUwx6jImob10Hc?=
 =?us-ascii?Q?9gbJ8In5RPAoitchiTkDZUWq+RjfVrDPT2sthYrmPzMfIGhhH8UnqkB6ZIUH?=
 =?us-ascii?Q?B1SOq+an8Urb01Ue8IBXt3v2krojCH2yhWT3mbPnuVJwbQZI2YfXYwBwSX8?=
 =?us-ascii?Q?=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6c3201-5364-433c-545e-08de225c69dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 02:29:04.1056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR02MB10774

From: Josh Poimboeuf <jpoimboe@kernel.org> Sent: Wednesday, November 12, 20=
25 3:33 PM
>=20
> With CONFIG_KLP_BUILD enabled, checksums are only needed during a
> klp-build run.  There's no need to enable them for normal kernel builds.
>=20
> This also has the benefit of softening the xxhash dependency.
>=20
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/boot/startup/Makefile | 2 +-
>  scripts/Makefile.lib           | 1 -
>  scripts/livepatch/klp-build    | 4 ++++
>  3 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/x86/boot/startup/Makefile b/arch/x86/boot/startup/Makef=
ile
> index e8fdf020b422..5e499cfb29b5 100644
> --- a/arch/x86/boot/startup/Makefile
> +++ b/arch/x86/boot/startup/Makefile
> @@ -36,7 +36,7 @@ $(patsubst %.o,$(obj)/%.o,$(lib-y)):
> OBJECT_FILES_NON_STANDARD :=3D y
>  # relocations, even if other objtool actions are being deferred.
>  #
>  $(pi-objs): objtool-enabled	=3D 1
> -$(pi-objs): objtool-args	=3D $(if $(delay-objtool),,$(objtool-args-y)) -=
-noabs
> +$(pi-objs): objtool-args	=3D $(if $(delay-objtool),--dry-run,$(objtool-a=
rgs-y)) --noabs
>=20
>  #
>  # Confine the startup code by prefixing all symbols with __pi_ (for posi=
tion
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index f4b33919ec37..28a1c08e3b22 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -173,7 +173,6 @@ ifdef CONFIG_OBJTOOL
>=20
>  objtool :=3D $(objtree)/tools/objtool/objtool
>=20
> -objtool-args-$(CONFIG_KLP_BUILD)			+=3D --checksum
>  objtool-args-$(CONFIG_HAVE_JUMP_LABEL_HACK)		+=3D --hacks=3Djump_label
>  objtool-args-$(CONFIG_HAVE_NOINSTR_HACK)		+=3D --hacks=3Dnoinstr
>  objtool-args-$(CONFIG_MITIGATION_CALL_DEPTH_TRACKING)	+=3D --hacks=3Dsky=
lake
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 881e052e7fae..882272120c9e 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -489,8 +489,11 @@ clean_kernel() {
>=20
>  build_kernel() {
>  	local log=3D"$TMP_DIR/build.log"
> +	local objtool_args=3D()
>  	local cmd=3D()
>=20
> +	objtool_args=3D("--checksum")
> +
>  	cmd=3D("make")
>=20
>  	# When a patch to a kernel module references a newly created unexported
> @@ -513,6 +516,7 @@ build_kernel() {
>  	cmd+=3D("$VERBOSE")
>  	cmd+=3D("-j$JOBS")
>  	cmd+=3D("KCFLAGS=3D-ffunction-sections -fdata-sections")
> +	cmd+=3D("OBJTOOL_ARGS=3D${objtool_args[*]}")
>  	cmd+=3D("vmlinux")
>  	cmd+=3D("modules")
>=20
> --
> 2.51.1

Did a normal linux-next kernel build on an Ubuntu 20.04 system, which by de=
fault
does not have xxhash installed. Previous error about needing to install lib=
xxhash-dev
is no longer generated. Have not tested a klp-build.

Tested-by: Michael Kelley <mhklinux@outlook.com>

