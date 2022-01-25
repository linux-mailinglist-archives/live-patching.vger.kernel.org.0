Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9CD49AC36
	for <lists+live-patching@lfdr.de>; Tue, 25 Jan 2022 07:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiAYGRC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Jan 2022 01:17:02 -0500
Received: from esa13.fujitsucc.c3s2.iphmx.com ([68.232.156.96]:33740 "EHLO
        esa13.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S256342AbiAYFVw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Jan 2022 00:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj1;
  t=1643088112; x=1674624112;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=1o7U0Y7Tu/hYHXorXJTFtRUqN/CPO689S4FzgDCzff0=;
  b=K7DTiAX/bu/NYORCYOcFZM9paLcTOUBeaGrnv6Ein3/P7SgSeH1uCrlV
   wKbgQqOLNkax0rgRkdtS9q7354vYxdZ0mQvqfQtBcIpKuuq1aW+tZDREs
   /QlRBdHMCEK1aZflC+SN7mPfUFSYITMaoTEQiNEtcU21ShWufwahJyV67
   FF+WSrLaiy7AJVteq4tEtjw4clyw1xelEyFEk7LVzN6jKbRPopw3PmjAY
   gvubpe4JgxqXXuaeTQzWgx+D8RyJZyelV1Xkp1BkEEY7z9fAPx4BQfRb/
   IaN5hfjEi4+6oWKjUq15NGMybsQYL9mOAhpkfdo1j1uyDdDcygly8j58p
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="48121015"
X-IronPort-AV: E=Sophos;i="5.88,314,1635174000"; 
   d="scan'208";a="48121015"
Received: from mail-tycjpn01lp2174.outbound.protection.outlook.com (HELO JPN01-TYC-obe.outbound.protection.outlook.com) ([104.47.23.174])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 14:21:31 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ho3JRiHdmOVAwExaazErgWvozEOgoU3u2InTGnT4WKTyaC3MoAeljamrjQ5rBOWhHP7XMGzFs8OuXUz7odPWFnkc1K6rVIZvp+qsdLAIDZveQoeGd6A86HWbsalq5+W4yfmUZgxzPD4DGsvaiI2RGYrfuF7xgWX03286VUZ0fOEQEbNoClix1XTF/rnBJD25Aaqci900CE0CMOzJd7rEOMzaLTovQjRgNluvhPAIt/mWrRmEI5J1dpUeYjszqMKSaEGFCOaOCSNhMibGcIg27eTuQD3N7rLKThuMDaTytXjHLE3S5kjlwSj0wZa/zW7cWhXYE+0srn2xDHG5lgaLtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YLbUUX+G2I2T8FR2U9/mpXMVEpaOGwcSXgoq9+e8bAk=;
 b=oMdcgK1h+CIgyTRYuB/0F16i40xsMOaxiVxAjkOzCf1kXqOH6C4QGqGLsR2Uouhhybe3ulePbkFlwq6bPJ5cUuOJ94diCgm1TvXbC7FhEnnf8Cm47R4qOwmL7iWmG+s8d9dM7URlgy9FDfNSQjeVTuV2qXxFHUJtizwurKln2ThMSZU9u+xxERR7gPAZd6SbtIJJsQSAmTGLDGq3Zq42zerYLA2+SkDXWkaabdufCSbX/lQREb2EuL09mRVKuSI6xHrdyeswG76N7sVTQWR5KQlNdLn0ML2sLCAm3eNWE+PmmNfGKog1tXnfKWYjGZEGNiHf5jPtjNmicPfndMGjgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YLbUUX+G2I2T8FR2U9/mpXMVEpaOGwcSXgoq9+e8bAk=;
 b=Lx9BPBVbL1xUabORlRD+fNGHMoALa+PTvYBGvSdECTYsL4NwMVOG5SanIR1ynrO1Cg8FaaZEBE8LrI94rZimdIeMZnHzomOFyVFz/gZva8nf4jv+X0CpxiXElzNwT9Ges5Es4rCV77jmVmyE4D/fK1WN3s2/ypvQRxo0g0dB4s0=
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com (2603:1096:404:11a::10)
 by OSBPR01MB1575.jpnprd01.prod.outlook.com (2603:1096:603:7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Tue, 25 Jan
 2022 05:21:28 +0000
Received: from TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207]) by TY2PR01MB5257.jpnprd01.prod.outlook.com
 ([fe80::30bc:c0c1:4bbd:a207%4]) with mapi id 15.20.4909.017; Tue, 25 Jan 2022
 05:21:28 +0000
From:   "nobuta.keiya@fujitsu.com" <nobuta.keiya@fujitsu.com>
To:     "'madvenka@linux.microsoft.com'" <madvenka@linux.microsoft.com>,
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
Thread-Index: AQHYC7J0j/1dz1/1vkuQ8Ct1CeQ76axzKz3Q
Date:   Tue, 25 Jan 2022 05:21:27 +0000
Message-ID: <TY2PR01MB5257518B8EB381E16D52B244855F9@TY2PR01MB5257.jpnprd01.prod.outlook.com>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-12-madvenka@linux.microsoft.com>
In-Reply-To: <20220117145608.6781-12-madvenka@linux.microsoft.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Enabled=true;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SetDate=2022-01-25T04:09:16Z;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Method=Standard;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_Name=FUJITSU-RESTRICTED?;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_SiteId=a19f121d-81e1-4858-a9d8-736e267fd4c7;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ActionId=2b55f2dd-a276-44f3-9483-73332c382755;
 MSIP_Label_a7295cc1-d279-42ac-ab4d-3b0f4fece050_ContentBits=0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=fujitsu.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7304776-a53f-48f4-9c29-08d9dfc289ee
x-ms-traffictypediagnostic: OSBPR01MB1575:EE_
x-microsoft-antispam-prvs: <OSBPR01MB157572756FDB1428FD9F8F5D855F9@OSBPR01MB1575.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HKwOSmD9qJnKipwmEhYWpdQyw2mZYvcqutPVYZQRlmcqhr9nCeCliVwpfJBlJslS7UjPEvFrDf0aar+/C5OZhYA0h3mpGQz9NtnWWAz7O8LuXekO9EarvNs3qQyU44sLlNT9X6gX0wGxpSsnra+QYNfk/cfN9+5kQQzrlfOKN0Xt04WbM8Q67L2TOBSIYIaGP1CrxQq+01M76Rn7lNkz3a8PpQ/koG9lGyRF1BHTQj+K9fpMbF/mS59STOFrFPoKMKJFsyZf8unebyS6Ps9qysTHQRaEmgAKR3tdWbgvVy/THVqUj4XYaCAmuYLMlbqb5ouVdWBDftl2XlJLzkxj26RSB66+q4DEb5BLaOzCXxrzPQL0DXYcNsLF3lhWZMzm6ZkKZZKAHGzsv/onyY3V9CyCeyEZpkwHdS5zIbJtT1b+zFDzAKcpszAW3PYa9qgmYLYrcAvY3bOClUXsd+lTEcSwJpEhvtkqsMFtIeqAM+dXsP08GvWR6A0S/3QKherP/TPYX5F40+/iHw4AqOMRiS1MB7iHGqfUmDXTOg6zu1ltJxKZe4iSNuYmkGyh74RzWs8DzxMF8JYllta1HmYq8okp55gOOB7STfRz36ONbZ69QZcpivhDHruervvSLtpEaAF9Mmbi9BnWZCDWGypXv6YLXp6ypoE0fNii5X+kFt6IATyaNFm6zIo26/Ea97LByFmsl1Rm6QaFeaoLFHmE1beBzmjLNlAdmdSBmN5cbSNB1MNRwXcB9CjQIqkzzr9sCY3EreU7/VnTqjB1PROZo6k2Uqot7wXGM+hABMtYXTQP/i2UoUeLOemodDAx/Pu+wVKn7JmUl3UDf7SALJJ43A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB5257.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(122000001)(38100700002)(8936002)(8676002)(83380400001)(921005)(66476007)(7416002)(64756008)(110136005)(66446008)(66556008)(76116006)(85182001)(66946007)(316002)(82960400001)(9686003)(52536014)(71200400001)(186003)(5660300002)(26005)(2906002)(6506007)(7696005)(33656002)(38070700005)(55016003)(508600001)(966005)(491001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?YnlqYnUxRTFDbk9PdHFocXdFK0RjNVBoTnJXL0w4TlZWTG1BZkc2aldw?=
 =?iso-2022-jp?B?OXBRZFFoR3N6UGJIb2trN2dnczhzQjZ6R1ZISk9aWlJaZFFaSHV2bTlT?=
 =?iso-2022-jp?B?NFNndGNWNW1DdUk4WEhMdnJWWVhrc0o0NS9POVNKOVg0NlI3MXorSUNN?=
 =?iso-2022-jp?B?UTZieWVzNUxmNTZiL2FBNUNPZGExeW5oWDVoRWVmcUJaeVZqdTZEU0M3?=
 =?iso-2022-jp?B?d21iOVdSaVNDbnN1RnN3bGpRZjdOYkVMN0t0R0FsdWVybjdML0VPZThE?=
 =?iso-2022-jp?B?TE8zNUhUQ2dGUEo2YmxGL0tHTU94VzdWWTJwYnIvS21YSGdjaUpuRHV3?=
 =?iso-2022-jp?B?Mk5tc044bDMyQ1RpM3p1eHA0dGoxamlRTXBDUlNiQTZEc3J5M0VlcFUz?=
 =?iso-2022-jp?B?Zkt6cEp2akZhdDdNa1pDTzM4Um8xcDV3MXZVQnhxRWI4c2EzaHBKQ0dl?=
 =?iso-2022-jp?B?Mk1QZTJLdmI3Ui9kVnU1SlRheXZncmRoQXlMN0VSamxNVmp6RmJkTis3?=
 =?iso-2022-jp?B?a0hEcGZ2ajFFcHI1RjM4TlVydmwxYk9qbWdEL0J6WmpkNE1YeGRCb0FN?=
 =?iso-2022-jp?B?ZHJTekltazN2TlpBL1JJcUFMYU0zK1lOTXBVWVhuL3ZIbkRGWGYydTVC?=
 =?iso-2022-jp?B?UUlQYzFaakZubUdOaTEwMEFwRmRYUERGSnU4MytSSUFYNElEVlk2eTVQ?=
 =?iso-2022-jp?B?UDcvdjVtRWZaOU1kWEV4TzNBMVBWMklJVnFiMHg3YVJteEUrQldKY09N?=
 =?iso-2022-jp?B?TWZVQjI2b0Y3RW9KelZ6NlZ6TVoydmJSem1PeU5Ed3dPQ1JUVzBXN2hh?=
 =?iso-2022-jp?B?clJYeTgvR1ArZERDblRBTW9oU0NrUDFNNThmaXhIZm1wNTV0RXJUUWh2?=
 =?iso-2022-jp?B?Z0RhdHF5d2xud1hwRkRmMkVnRk9wWllnVUx1M2xYUDNydWpYbnpCNEJt?=
 =?iso-2022-jp?B?Y1Z2anE5bWxYeWVuQmgvZlFyVDl2WkRQeFk1YWFnVDdSSDVsMEJlM2tL?=
 =?iso-2022-jp?B?dmNLelB6Q3JFZWhUWU9QaS90NzAzTXpxZVdMZVBoc2hINm5aSE5KdDBs?=
 =?iso-2022-jp?B?QTR4ZkViSWpXRlhFdkNDVFZVL1lMREVoaUNpeHRVZi9CUW82Z2FsZW9N?=
 =?iso-2022-jp?B?YVhNSVI2NGZJM0Rud1FJZlNXT1J3b3hIb09DSkNoc0RrVmkwVHkrWDFT?=
 =?iso-2022-jp?B?KzZDTjExMkRnRElmRkcybjNkS2NhNzFkS1Ficy9PSnhHKzdrM1JPSlJj?=
 =?iso-2022-jp?B?QkF0dk9rWXVjNG8rZStwQUtWMWhmRG1FM0pyMHRLZUNjTjBNUWQvM2NB?=
 =?iso-2022-jp?B?cXhMLzR0K2x2ajFhTnNjcUdDS1FSQTAxLy82MUFoVm0wSzNoUUw1bElG?=
 =?iso-2022-jp?B?TnhlRnMwMVRaQ1lOWGVJemdaM3hOUEFEbjBLc25sTDE3eU90T3g5dFB5?=
 =?iso-2022-jp?B?WWE5c2ZqdVc1ZC9NQUQwa05ORkJQbWVIOCtoNmNjNFcwWnI4K1VSWXZC?=
 =?iso-2022-jp?B?VmZXeE5ISVp4bm9IdDJrL0pQdUFDN3NqRmlxVkpVMFRlcUxzUkxHV29o?=
 =?iso-2022-jp?B?djBMajNZaUFwVVdvZHh0d2J0SE9VMUFJNWVUVW02Rk4vRjhPZ3MvaVZt?=
 =?iso-2022-jp?B?K0lHck94bW5aaVkwRWFRSnYzWGlQY2N4MFpLZ1N3TmFnVkxTU1BIUUZY?=
 =?iso-2022-jp?B?amZ4U0ZCVFNRRkcxdnA3d2FYRHRodW9TSmNxcUNKWFl3YUQ5Y1hlUWwv?=
 =?iso-2022-jp?B?Q0NLYjgvREpXZ3kwUjZSZittNWhxOVZKdFVBSG44a0sxRlN4UkNGellB?=
 =?iso-2022-jp?B?KzJLdlIzdi8vR0xLelF5aU93NTc4VGVDRGx3L2NwR3pocjZMR09aL20z?=
 =?iso-2022-jp?B?T0FrWWFzNFVNRGJydmZpUWVZZW1DZXJLY2EvZjV2ZU1QbURNMzF6OVQv?=
 =?iso-2022-jp?B?RTFrbHMwMXNFWkNwWGU4N3RVK3VKM3cyT2VoemtHc1BwTVFlZ1hMNm1M?=
 =?iso-2022-jp?B?OU52RDAyTjc1Y0hzYXpjZ00xeW5EU2VnNGVENmVkSWdXVDR0K1hRd2dz?=
 =?iso-2022-jp?B?T3lZYU1nNEZJWDZQOVE0bjRxVWFRUitsdCtZNEhCMjE4RG1PMC9rRE85?=
 =?iso-2022-jp?B?RXFqYi9SbExILzJwZWFzS3dqUTd1NEZNamtWYk1USUx2S3A2TEhpUHdl?=
 =?iso-2022-jp?B?ZzlEVitLOVRiQXh0VytZWlBxVGtvZTV4MDFnTzNrMGhUZ0hkOHlLYlM4?=
 =?iso-2022-jp?B?SnQ3ZklBWUNreEwxNFdlL29UMzc0dFh6UzZWa3loUndsaStwWlhCcURQ?=
 =?iso-2022-jp?B?YWRzdHl0VUg4RUVGQUs5ZzY2eU1kM3hKb0ZxY2Z2VUowV21lWERGelpy?=
 =?iso-2022-jp?B?TVhrQVVBc0QzaW9DbWM4ajRFODdWUUppeGNWVmhtS0JIN1dPMDhYejBJ?=
 =?iso-2022-jp?B?S0hOV0x3PT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB5257.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7304776-a53f-48f4-9c29-08d9dfc289ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2022 05:21:27.9620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZrrepEXuTKEpzCXCQSyIPPAP4DqMpdJKy4W34oaYM8el26QQITWoPez4u7+RJG/5razjCeQQ5zJM5kx2HOk01i6P2L5y5PPAKwNx9yq2Nr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB1575
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

> Select HAVE_RELIABLE_STACKTRACE in arm64/Kconfig to allow
> arch_stack_walk_reliable() to be used.
>=20
> Note that this is conditional upon STACK_VALIDATION which will be added w=
hen frame pointer validation is implemented (say
> via objtool).

I know that Julien Thierry published objtool support for arm64 [1], but I'm=
 not
sure if it has been updated. Could you tell me other threads if you know?

[1] https://lore.kernel.org/linux-arm-kernel/20210303170932.1838634-1-jthie=
rry@redhat.com/


Thanks,
Keiya

>=20
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig index f6e333b59314..=
bc7b3514b563 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -223,6 +223,7 @@ config ARM64
>  	select THREAD_INFO_IN_TASK
>  	select HAVE_ARCH_USERFAULTFD_MINOR if USERFAULTFD
>  	select TRACE_IRQFLAGS_SUPPORT
> +	select HAVE_RELIABLE_STACKTRACE if FRAME_POINTER && STACK_VALIDATION
>  	help
>  	  ARM 64-bit (AArch64) Linux support.
>=20
> --
> 2.25.1

