Return-Path: <live-patching+bounces-1798-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BC70FC07074
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 17:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B7471C25A2E
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 15:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D5132C336;
	Fri, 24 Oct 2025 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="VlkifRd3"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB6C32B9B2;
	Fri, 24 Oct 2025 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761320572; cv=fail; b=fbxYyjc/kplFsP+7B5MbgwI0Yf+CibRsN253MzUOQhFRVSBlOQpmiPctPEJ0q7smCqRqpuLuy8PRAWyMHPjcqhV4LDGAIh8HgKZ1U882hb8n0LOJLthlrpzY5jOcXDiDfe1slNUiT/fmKp1wzmtJ3vKG6Bv6DcLHAKlihQKg/BU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761320572; c=relaxed/simple;
	bh=gzQ3blzbxpyiUGjr8Bh8puN6GX1H3x63A/nXlkaYyfw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vBt1rEV+JQ1whqXNGBrS5OI3dWw6B4ZVT5TUEJmHGOac1aJmYYxgFLGwQ/lyQUOlrMtfwLtsNN78+74iwtGYAZiEuMSiQUYk86FCbYUvd0+tcYUMPHT64t86rSgxI0RKNtx51gPC1w+dm4PnKUC+5TOVerZJK6lNW7X8YzLZ5Oo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=VlkifRd3; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59OF9v693325260;
	Fri, 24 Oct 2025 08:42:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=gzQ3blzbxpyiUGjr8Bh8puN6GX1H3x63A/nXlkaYyfw=; b=
	VlkifRd3t9Yk8EXTm79uiA/9aa/BLRST2iLlX1u8RRJzCBv4hz82uDjpXnFz/zrQ
	mhUzpkyzmoohoO9MAJ/8rm2XEqE4hVmW15HIOQqNZDJBygUYy7a6qAT/RJ4D8jhR
	8r+EVKFSqdtAvy/DyZAIzzPTEXE9J+9ec8rQNK1PX9RZAoRINPUC3Rf1cS43MIWd
	FuEEVMp1WvORXgRroOgO6hX9euy3ExCw2LOx0lTKQ4MQ5ykEl8PFeT3cjCtxzZQ/
	EQ7iyQsVld7oAsc+q2+zXn3TV3tAbvGbdhKtlCHN+sdXba3boQoBjbUE3zqK6O1Q
	baDTJ1wx+Ek1jkz5Ef3B+A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010071.outbound.protection.outlook.com [52.101.193.71])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a00qt3vh6-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 24 Oct 2025 08:42:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zOPfbNFPV4/iLu9B+7ugMz5g+Lv+XQv/Cex2gO85GmQMdWENjh6D+1esDA8CdiJCpuP4GxtHnBMyOPN6mH5Z7wVSRzyce/m8/ivFdQVlfXcRvtwmDzRDLBgGE4Mw/7mgrWeOeNo/4G53TlYVSEroez41YAFUvZAcceByVos7PRXjGYwU2DpOr/84fzBBMbXdCMErkx6l0npFaVJg/HiyKJ4nvFhFLbS+JSJaMFeSPJJf+KeTzbjokW6zWv0zWCkN4emmFSPM2S8CmwsrEKVE4iHykLY9I50IIkq0cIb+vNeH3a+GGgaYm0Dmt2fvejWfvOCFkL++NCB5kFpfhCmHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gzQ3blzbxpyiUGjr8Bh8puN6GX1H3x63A/nXlkaYyfw=;
 b=C+S1Wagax4lXvUFJxeKvdN1s7Y5DbjicBypLaX6UioZ7ovyMqSj41UMozz5ZW/RC1vdkOJM7S24xrnSPAIen/KpLKs09eN1F+SPNsfymoEK+GiVL+yuFxOhP84bpCoz1oAXTh34saniSnGgvV6XiX98nja6CHAf1hD/S7BypIjGefLnGdW7ibgae5B42DljmqqR4rmId/ckO4XPB1NeY0xeXZkjTvud+jOZFja6MoaMR/1GRYwIH1sbSK1LRVYkNEkrMAnEd7sN0a56Pz33XGuR95LjPTUW33qKIgT6aErw9fetthRaHRLfiqdOd3Q1BJj9zZ3RY3HD7eTwX+cnHgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA3PR15MB5632.namprd15.prod.outlook.com (2603:10b6:806:31e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.14; Fri, 24 Oct
 2025 15:42:46 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 15:42:44 +0000
From: Song Liu <songliubraving@meta.com>
To: Jiri Olsa <olsajiri@gmail.com>
CC: Song Liu <song@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH bpf-next 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Topic: [PATCH bpf-next 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Index: AQHcRLWstk3pYtWhXUSBVKcp8FM6crTRLTgAgABC/gA=
Date: Fri, 24 Oct 2025 15:42:44 +0000
Message-ID: <F4D3E33F-C7AB-4F98-9E63-B22B845D7FC2@meta.com>
References: <20251024071257.3956031-1-song@kernel.org>
 <20251024071257.3956031-2-song@kernel.org> <aPtmOJ9jY3bGPvEq@krava>
In-Reply-To: <aPtmOJ9jY3bGPvEq@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA3PR15MB5632:EE_
x-ms-office365-filtering-correlation-id: 4df0304c-cf8f-4893-e3dd-08de1313f9ac
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|10070799003|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?eUNML210U3lDc3h5amd1ZWJlQzA5Q25QTkhhbi9pd2tORVpGbUtMcXlPOVNK?=
 =?utf-8?B?T29qa052NjM1OGxPS2dZK1oxb2puM2NyNWI0NkVYeTQyUDIxa2Y3NjhKOGxm?=
 =?utf-8?B?TFBiaE9Tc1pNdDlSK2h4cm9XaDVoK3pYd0dndDc4TXhTTFlwWER0c3NMUW1B?=
 =?utf-8?B?emFRWHVhdnRhdW9WM01USWdUWUNVT2RQcHhqV1hyUjRZanBQYjhudjJKNnpl?=
 =?utf-8?B?K1VhRU9BTVJHaG9sVENPWWtzQXJLVUxMWjVleDd5aWY0RjQ1QnQ3by9qclZ2?=
 =?utf-8?B?R2ViZEx4RnZrckxPSU0xT29HczNCZDEyQ3VQZU1DNTRtYU9qZDk4UDBQSFlI?=
 =?utf-8?B?MXdhQ0ZseVIwQTlEbTArVU11aU40Mm1XUWpvbmhNSXN1c2p3MFlmVnA4a0w5?=
 =?utf-8?B?RE1jNHlJdW1SOHZHN3JZVUptQ3JyTXhJZ0RneEdyUDQ0RnZ3K0ZCWGRRMCtZ?=
 =?utf-8?B?WFV1T0xab0h2cEgyTTB1c0Jjd21Mb0g1UFd3Mzd4T0V3VC9CMGxIQW9hVmx4?=
 =?utf-8?B?RmRwTm01Qnc5NUFaSzlNS2xJVjcwTmZOaklGZ2dZOFBFbzNqUkFvamNPMFM0?=
 =?utf-8?B?UG5pbWZiRVdneDdLeVpqQzVQSFJvU3QyTEx5VFVHeHZESXJXamxIc1A2KzU3?=
 =?utf-8?B?ZWRMb3liYVBjeVlmZDRkenA4NnN3ekNYUzNjbXBzM0w2T1Mra0R6dnU3d0t0?=
 =?utf-8?B?SWRucFZCT3JvMFp3U0d4bjQrS2NRZXlMNXFONVNkTG9GRjB1Umg0RjNiaUow?=
 =?utf-8?B?T0pEYVhGbzUxM1NyaTZyakU5aFNVNitrWUUxSVNxeTBselA1RU5LSURsbnBz?=
 =?utf-8?B?RlFiSEtmUnJnU1NOZU1zOGgvWnlYK1Qwa1hzT0lQRnhJeVFZWE02WnRQU3F1?=
 =?utf-8?B?WXJjVUwzUnFGT1N1M2VNTFVKWlZSOVhkWE1EVmRRdklxdW5JK3J1K0xEeVk1?=
 =?utf-8?B?dEwzUjl5ay93eWVVNWZFS0QwMEpSdzNudHY0eE9tWkY4ZzY3anRtYnZOdGxt?=
 =?utf-8?B?MGVkd3VhNGR6M3ZLMVB0WUdDSUFxNXhYdnhEcFFTdGFDamdaQVlhUDAzUE15?=
 =?utf-8?B?TGorYmR0cXE1NVVtcVUyWGt5TXB6bGtOOUhhanJSbHRFRzBhclFDNG5GMTlk?=
 =?utf-8?B?UjdYR2lSTVl0ekpxcVBkSWxWRlZJdndQY2ZwM0dXWitjQi9OVW80UE95ZDlv?=
 =?utf-8?B?M0g5L2o0KyswejRPMElxK1JlWitpeDMyU3JXdkppd1dCMWxhYk9oQTRTQUdJ?=
 =?utf-8?B?c0NFTFQ2Mk1ONzlaTDBWOHNXUUxIVjl1WUExRk9QVnZPdTE3ZytKRzVUck9C?=
 =?utf-8?B?Z2ZxRE40a0RSS2MzbkRFbDJlTTRiQjRHSEFtZnZUWjFOc1BXUWlScEY1N2dM?=
 =?utf-8?B?SndDSjlXZWpGbmRyeDBkRkozQ3VTRTU1M0phWXZIS0Z3ZGdRZE42M1c5Z2FS?=
 =?utf-8?B?RnBnSlVrcjh6U3JvRmdDbkJvVlBnMjFlWjVlbjh6OGdtMlN2Yy9TYjM1Q0gy?=
 =?utf-8?B?RUdxSGJRTmNFOXRWUW9UditlanNQMU5jaGxYYmdvMjJQZlNKNnRxS3pqcmpt?=
 =?utf-8?B?WXhya1RoVDJDcExEdTg1K3VTM3BVL1BFa252N1hFS01wa1JyNFJaUGxLTVc0?=
 =?utf-8?B?Ump1MElXM2E0MnpTdGh2eUpRQzZyQUZGV3BudTluaFpoandZeUorelpSTGls?=
 =?utf-8?B?dW9NQVVuT1VTU043S0taU2NicXMwRnlwZ2F6YXorSUlRRUZURldSYmd0elo3?=
 =?utf-8?B?SU5SWXBaV3pQSnF5MTFCaDNaQ0MwVDdTYXZ3UktmWHJJRUovYUhhMnhqNWhK?=
 =?utf-8?B?R3FPU0xxUVFvM29waEVXRGNSZklBN2hwcXlZb3hmRHhpR2JKOUlhNG4vMnhN?=
 =?utf-8?B?UjJ1Q00yaERyaTZ0VHY3Q1Vpd0RXaHE3UVRweHdxOUVaenJneFc4SDhqNzJm?=
 =?utf-8?B?eE5TYWcvUWxpcHdTZzVtaGNWQThOR0pTc0pLU1F0enA0WFk4SEdRYXpHTVZz?=
 =?utf-8?B?N3kwR1RTSy9BWE5CTzMybVZaeGZqaENUdGZpVWFwLzE2Mm52NG9XQ2dlR0dj?=
 =?utf-8?Q?7yVhki?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(10070799003)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUYxM1dvTHppbGtjei9RN05BbktCSkdGK2tsREpuVGlRVnB0QTNESk12QWJN?=
 =?utf-8?B?QlFNd2ZDaWd5S2cveWtVVlNFaG01Ti9WLzk1bUlmQnZEemJaUXVYZzkwOHNP?=
 =?utf-8?B?M3JhQkg1VE9LdzhNcDdrZlNLZXdnZEhabld6THRDTngzK3BvYllvRjIwdHdL?=
 =?utf-8?B?eGxWVnZ5UHFZNUc3VnNESVRnQVNvTC9DZ3pnZEg5TVUzelZuQitlcFVUZEhN?=
 =?utf-8?B?T1gzKytzNmlQM3czeUFWdHFuclk2VTVtSXFuUWZodEo5eWRYNjB4WXVxQkVG?=
 =?utf-8?B?KzYyOGgrZDZ1UWd6cnlSS1pjTERjVkgwaC9IQ0V0SkJGMXpsSTJqQk1vR29J?=
 =?utf-8?B?TmIwcHhtK2toNHJnZk0wcStiSDg2OUxFdThrMjNzK2ovdys5ZnFkMkY4bnly?=
 =?utf-8?B?NG4vRExhODNRUEthd2lGd1BaNzlXZlgwNFBBZjVKS0ZIeFpEMS8rdDBqdVVO?=
 =?utf-8?B?WUo4Uk1IQ01mWitPOGZMUW5RRkpxVXJ3cmYzc24zcHlXWm1zT2p4a3pURGRB?=
 =?utf-8?B?Q1VHWTduQUZybFd4ajR4NExiVEJ1YjBnSmhhdm5xZ3B4c2tESnQrN2pWL3Rs?=
 =?utf-8?B?eWtqWlJsalQ5VGpxUGJUMEgxcU5UOVNzODlXMWlIcnF2eGVzSGRoTlNub0ps?=
 =?utf-8?B?cWZLQnlaRksyMk1xZjY1Q0dJNDZaby9Cd09Wa0ZZNHZST2tmSytsbm5YL2N1?=
 =?utf-8?B?cDdKd05pNkJWQXR2NkpmRFgrWFcrOW5vT3RJTmdOQ00xYWhHb2Z5dEtqWmdY?=
 =?utf-8?B?c3BNMDV6WHgvNHFrQnQ4RjlWLzgxK1Nzd0lxMTFHVVZmeEQ3UkdJM0xuU0dr?=
 =?utf-8?B?a04xYk94Sm9GSm1XS21wUzhXMVFsWmk2SFUrZHV4NXVTRVR6YUhzaFI0ak9S?=
 =?utf-8?B?eGdqN0haTG1IblRjYVVrZHZWcFlYRGdSODdPTm8vOWE4SjZZaGtCdytTbmJu?=
 =?utf-8?B?T3BVSEhSalVPMnBqMFJIVTluR2RlZUZ4OUJmN3BRYnVQRkFNdjVBbXQ3cENM?=
 =?utf-8?B?UzlTS2F5NGVtMVNMajUrTWpXQno0VmFZVjByb3lmNDE1RVp1YmpFODd2UDhC?=
 =?utf-8?B?SVR1UVJQM1M2eGFabW9xN1F5d3FpMm1TdEszUzE1bDdpTEROMXYyeU5tSldq?=
 =?utf-8?B?bVpLTVBjai96NXFlcHdEd3JRdEx6bWxZTFYvVk5qZDNkeTNyaUxXanJvekdw?=
 =?utf-8?B?ekRQYjBNS1BRbjFQUENMemNwcHJuWGNhVjBPbTg0Q3FMTHVMaEsrZGEyaS9E?=
 =?utf-8?B?bElQbW44enJ3OXVoWXJaRXNXWFNLbFUrVGIrMHFmRDZvVHB3QmVuamVZaEFx?=
 =?utf-8?B?bXdOK0drOThxcGlWaHltY1k3Wk4zWmE1TURoL2FqZi81QThWVnI4Y2xhMWtl?=
 =?utf-8?B?aWJ6a0xXZlpCQkx2SVh3VjBTWm1peXNtSkNDMmk0NVhYWjNRM2c5QjUwOFBa?=
 =?utf-8?B?MnRZT1VFU0lQUUFrdUJBMVJDY1M4Tk4vUGtQQXRtbUtQTHFZdG5LejRyWHdi?=
 =?utf-8?B?bW1CRHJKbzQ1MzNaT1RBSU55ajBIUkxpRDdoV2pPbjE5dC9wWFdFVnhjQ2NK?=
 =?utf-8?B?aGoxU0JvcnRiM2FZUzdJK3dRc3MzMUZ6U2xxdjJxRWJlbFVtenA4MkRPcFhu?=
 =?utf-8?B?UEJUWk5Cam1MY2EzMGdac3l4cGRFV3l2L1JNVldLMjZmbHBWOFlFY0ZnQ09X?=
 =?utf-8?B?QThCaThJV2xkTE4zN28zWG5GRjU2Zys4TWdkb215RXFzRVJwNjVhUHpiZ01h?=
 =?utf-8?B?UnMvL0NrTnBXNW53cnRISXNUZC9CeUs0L3hwTXdjcUVCSFRoVXVWeWJ4b1NX?=
 =?utf-8?B?SHQ1MHdjazkzTEVneU5TSjVWVFpNUGl6QndlaTYvbmxtOVhPSHVTeVJKL2V3?=
 =?utf-8?B?T290RFp0NVdZNlZLdHdVQTlSYURzbUFSUHk0d2NtbXBGZkxOWDFCQTRZSHJD?=
 =?utf-8?B?T09CbmJPb3JnTTR6NXc5a0xkVzhuSDZWUy9nRFpHQnhNbEVPZWR1TEJyMU8v?=
 =?utf-8?B?ZU9ab1dCRFd2a2ZZQi9IVEhJT0VBcC9sclgvZWFCQVZsL2JYUmNZS3FUa3l3?=
 =?utf-8?B?VlZNUVNKUGF0bEN5Q1Y4cXF6c2hxZmF5aDBoWnhZM2tqZXlBN1l3NFZRWnRp?=
 =?utf-8?B?a0lpNjJ6QVZpTC9OKzFXV3JYcFZGbTgyeVdmRG5ZQ0ZhMlBWZk9sZzNBTDZB?=
 =?utf-8?B?M3g1S3ZKcC8vemlZaGpuK2l6MTFnL3U3OXpsejJOQzhrcXZzMzZxb0NNNHRy?=
 =?utf-8?B?WlpLdTExNWRFeGk0ek1wVVV1Yk1nPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E290FAD91265CA4497AFCBA0B87A1411@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df0304c-cf8f-4893-e3dd-08de1313f9ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2025 15:42:44.7089
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uUil9O6/mmzM/vyWHlkJof09nYb08c0RgVciq8HqczAOwt8yoCmw6ixr0uYptjwEGW49oStQVdmXG06ydSKSHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB5632
X-Proofpoint-ORIG-GUID: kiB1UsPxXkv8MSsbVELE0K3o-bYYEZYn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDE0MSBTYWx0ZWRfX6XjAsclMaxDR
 RcYl7SSNrgKZXyt6pIZiQN/D+vyOqRZfmjybiMnB0t9AQRXBv7Vu9310Z1nOzkb4lDMi1JG+e1v
 cR2ebj22M/f8bp4JEXXp3lcaMorsNzqyCqp/BIogIhIyRN+xUGlbhPA7wXq6undXoDtg3ME1XrB
 euJKnJtVrAEKPefg3+Kb6Lar6Sncu3l1Odbs83CaWHJ03WuIBb5Z6AAP5DkYvq0kFm2WDweZi3T
 Nher7AFmmt8b2uz1l524h+zXrEe5ayQLwOu1pN5nabM5aU7LmWs07nsIW1Ez9p5/ttKwxZeUgyJ
 mdpKRVejthfPlEUCfX0W+TWc6jspIV0spfKnt2Tx0pirrU9Mf8iD7kC3acPzL31W3v9f4LzHgEX
 SBpYFMaUevkgHNWyqezp9SGRDjGvzQ==
X-Proofpoint-GUID: kiB1UsPxXkv8MSsbVELE0K3o-bYYEZYn
X-Authority-Analysis: v=2.4 cv=I5hohdgg c=1 sm=1 tr=0 ts=68fb9e79 cx=c_pps
 a=/fsfGrOPy16csppsbskbtg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=pl6vuDidAAAA:8
 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=XuS_cIleqAqBKHKdNkIA:9 a=QEXdDO2ut3YA:10
 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_03,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI0LCAyMDI1LCBhdCA0OjQy4oCvQU0sIEppcmkgT2xzYSA8b2xzYWppcmlA
Z21haWwuY29tPiB3cm90ZToNCj4gDQo+IE9uIEZyaSwgT2N0IDI0LCAyMDI1IGF0IDEyOjEyOjU1
QU0gLTA3MDAsIFNvbmcgTGl1IHdyb3RlOg0KPj4gV2hlbiBsaXZlcGF0Y2ggaXMgYXR0YWNoZWQg
dG8gdGhlIHNhbWUgZnVuY3Rpb24gYXMgYnBmIHRyYW1wb2xpbmUgd2l0aA0KPj4gYSBmZXhpdCBw
cm9ncmFtLCBicGYgdHJhbXBvbGluZSBjb2RlIGNhbGxzIHJlZ2lzdGVyX2Z0cmFjZV9kaXJlY3Qo
KQ0KPj4gdHdpY2UuIFRoZSBmaXJzdCB0aW1lIHdpbGwgZmFpbCB3aXRoIC1FQUdBSU4sIGFuZCB0
aGUgc2Vjb25kIHRpbWUgaXQNCj4+IHdpbGwgc3VjY2VlZC4gVGhpcyByZXF1aXJlcyByZWdpc3Rl
cl9mdHJhY2VfZGlyZWN0KCkgdG8gdW5yZWdpc3Rlcg0KPj4gdGhlIGFkZHJlc3Mgb24gdGhlIGZp
cnN0IGF0dGVtcHQuIE90aGVyd2lzZSwgdGhlIGJwZiB0cmFtcG9saW5lIGNhbm5vdA0KPj4gYXR0
YWNoLiBIZXJlIGlzIGFuIGVhc3kgd2F5IHRvIHJlcHJvZHVjZSB0aGlzIGlzc3VlOg0KPj4gDQo+
PiAgaW5zbW9kIHNhbXBsZXMvbGl2ZXBhdGNoL2xpdmVwYXRjaC1zYW1wbGUua28NCj4+ICBicGZ0
cmFjZSAtZSAnZmV4aXQ6Y21kbGluZV9wcm9jX3Nob3cge30nDQo+PiAgRVJST1I6IFVuYWJsZSB0
byBhdHRhY2ggcHJvYmU6IGZleGl0OnZtbGludXg6Y21kbGluZV9wcm9jX3Nob3cuLi4NCj4+IA0K
Pj4gRml4IHRoaXMgYnkgY2xlYW5pbmcgdXAgdGhlIGhhc2ggd2hlbiByZWdpc3Rlcl9mdHJhY2Vf
ZnVuY3Rpb25fbm9sb2NrIGhpdHMNCj4+IGVycm9ycy4NCj4+IA0KPj4gRml4ZXM6IGQwNWNiNDcw
NjYzYSAoImZ0cmFjZTogRml4IG1vZGlmaWNhdGlvbiBvZiBkaXJlY3RfZnVuY3Rpb24gaGFzaCB3
aGlsZSBpbiB1c2UiKQ0KPj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgIyB2Ni42Kw0KPj4g
UmVwb3J0ZWQtYnk6IEFuZHJleSBHcm9kem92c2t5IDxhbmRyZXkuZ3JvZHpvdnNreUBjcm93ZHN0
cmlrZS5jb20+DQo+PiBDbG9zZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpdmUtcGF0Y2hp
bmcvYzUwNTgzMTVhMzlkNDYxNWIzMzNlNDg1ODkzMzQ1YmVAY3Jvd2RzdHJpa2UuY29tLyANCj4+
IENjOiBTdGV2ZW4gUm9zdGVkdCAoR29vZ2xlKSA8cm9zdGVkdEBnb29kbWlzLm9yZz4NCj4+IENj
OiBNYXNhbWkgSGlyYW1hdHN1IChHb29nbGUpIDxtaGlyYW1hdEBrZXJuZWwub3JnPg0KPj4gQWNr
ZWQtYW5kLXRlc3RlZC1ieTogQW5kcmV5IEdyb2R6b3Zza3kgPGFuZHJleS5ncm9kem92c2t5QGNy
b3dkc3RyaWtlLmNvbT4NCj4+IFNpZ25lZC1vZmYtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5v
cmc+DQo+PiAtLS0NCj4+IGtlcm5lbC90cmFjZS9mdHJhY2UuYyB8IDIgKysNCj4+IDEgZmlsZSBj
aGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFj
ZS9mdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gaW5kZXggNDJiZDJiYTY4YTgy
Li43ZjQzMjc3NWE2YjUgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwvdHJhY2UvZnRyYWNlLmMNCj4+
ICsrKyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gQEAgLTYwNDgsNiArNjA0OCw4IEBAIGlu
dCByZWdpc3Rlcl9mdHJhY2VfZGlyZWN0KHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMsIHVuc2lnbmVk
IGxvbmcgYWRkcikNCj4+IG9wcy0+ZGlyZWN0X2NhbGwgPSBhZGRyOw0KPj4gDQo+PiBlcnIgPSBy
ZWdpc3Rlcl9mdHJhY2VfZnVuY3Rpb25fbm9sb2NrKG9wcyk7DQo+PiArIGlmIChlcnIpDQo+PiAr
IHJlbW92ZV9kaXJlY3RfZnVuY3Rpb25zX2hhc2goaGFzaCwgYWRkcik7DQo+IA0KPiBzaG91bGQg
dGhpcyBiZSBoYW5kbGVkIGJ5IHRoZSBjYWxsZXIgb2YgdGhlIHJlZ2lzdGVyX2Z0cmFjZV9kaXJl
Y3Q/DQo+IGZvcHMtPmhhc2ggaXMgdXBkYXRlZCBieSBmdHJhY2Vfc2V0X2ZpbHRlcl9pcCBpbiBy
ZWdpc3Rlcl9mZW50cnkNCg0KV2UgbmVlZCB0byBjbGVhbiB1cCBoZXJlLiBUaGlzIGlzIGJlY2F1
c2UgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdCBhZGRlZCANCnRoZSBuZXcgZW50cmllcyB0byBkaXJl
Y3RfZnVuY3Rpb25zLiBJdCBuZWVkIHRvIGNsZWFuIHRoZXNlIGVudHJpZXMgDQpmb3IgdGhlIGNh
bGxlciBzbyB0aGF0IHRoZSBuZXh0IGNhbGwgb2YgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdCBjYW4g
DQp3b3JrLiANCg0KPiBzZWVtcyBsaWtlIGl0J3Mgc2hvdWxkIGJlIGNhbGxlciByZXNwb25zaWJp
bGl0eSwgYWxzbyB5b3UgY291bGQgZG8gdGhhdA0KPiBqdXN0IGZvciAoZXJyID09IC1FQUdBSU4p
IGNhc2UgdG8gYWRkcmVzcyB0aGUgdXNlIGNhc2UgZGlyZWN0bHkNCg0KVGhlIGNsZWFudXAgaXMg
dmFsaWQgZm9yIGFueSBlcnJvciBjYXNlcywgYXMgd2UgbmVlZCB0byByZW1vdmUgdW51c2VkDQpl
bnRyaWVzIGZyb20gZGlyZWN0X2Z1bmN0aW9ucy4gDQoNClRoYW5rcywNClNvbmcNCg0KDQoNCg==

