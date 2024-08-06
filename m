Return-Path: <live-patching+bounces-443-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5046D949865
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 21:35:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0615E28328F
	for <lists+live-patching@lfdr.de>; Tue,  6 Aug 2024 19:35:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1253114B06C;
	Tue,  6 Aug 2024 19:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MbWMHCPJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBB3823CE;
	Tue,  6 Aug 2024 19:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722972913; cv=fail; b=MfDUpZq+PK8/aqZCXXAlrXq+9wmf/mIZBP/Bpqw/s+NqRInqjPg2j7r5Y2KM1eqKtqS5GL2zsMPIRldApkGSR2Hyk/+i8KZMnXiLSBB458ld0p2k9mG4RsCiwcC4z5U6GQg8qYNv25cKvBQbN/pIUtyjY5DdqEGlufMn3astL6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722972913; c=relaxed/simple;
	bh=R8Xq7NCa99UQglIXk6xtTwtrWJN3oxx96+Sw30CkQ9c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a9SibyLE/zKmKRNbmh9GtRxaFXncbEWx+9AeUSKoqYMNJlHJUszPUIvAJtx78+qSEFrwA6r7ntIyyYR/Eow2mYdrLidFYg78fGgPmS7bF2/9i9LMDBoGtv22CFp3DCRiZapN8Rcw1kuVxlzRquNmM8aD9ymOd5AH0JhD1Ui3MiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MbWMHCPJ; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 476J5Ynn022054;
	Tue, 6 Aug 2024 12:35:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=R8Xq7NCa99UQglIXk6xtTwtrWJN3oxx96+Sw30CkQ9c
	=; b=MbWMHCPJsHc3S+4Bpr+kDr+zPAK+7z3czZTLeqH+0Wz5psEWtJo5NutcBa7
	OxAjdgZRArSNwq7ld/tghFrbxkqz6q2DXpYXO7NkgOedwlqWbOzuh5eNTNJfLsGJ
	3xOaGGsLqJqG+8gqYcxb8quOSu05Ep1B5g698jaCsKYODmjv48JCRFD3VaRhbjN3
	l3sHZd0wPNv7J0Wgye7ks4HzxX5m2cSryq0VOUhd6QdskFMIMf/8wrEPqj8WQ9su
	p0IQVukhDanm6IxhTFGQPens/nX8HxvOK2NIIJNzZkpuM4+A56u7mktgaK5so7JR
	wO+hZMrs8StWK6woK9Ifx70Zo8w==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40usnkg759-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 06 Aug 2024 12:35:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LgnGD7FPP6vwUjiGituWJYiIghlcvI6tVdsV91T4vT7N57xSVQG8y0wbFs4GeUP535pcOd/FAuokiH8GCCciS7qoQxQ2kV0NKZYl7nKZ+456+H34iNvp0mve6fcl7ySyCiqx4a6ZbUQTWXmKkN4yhyFXTBLIhWe6kYAyChqRqqSRyXnEQLkoHFflIaB99F3JdjRMo2eDZQnpiuNaveU0Z0TBG+vKB7HSNIZXrCkET+/2Q6DYN92ZqffCvUnBVbtgFS/oEHEHhYhzCzvQX+hLWR+TxuxKchUvdVPrB/Rj3nGvl2DookzKWPsMglrRiSbvAQ6hM8Rj7ZcX0V/GjB2h3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R8Xq7NCa99UQglIXk6xtTwtrWJN3oxx96+Sw30CkQ9c=;
 b=tN0ktS39mpXmVqv0HKFBgr2ekmYEnlMkw8FVQg4TPt9aeAz2qmcLcJ+6dGKHmaWlQqrcIgNIyEVu5C5/vjMxS17MHg9/mqS9tg6AMrnj6hRNnfim/6BIVExMTVWGt42WPVrOHfUQGpEhaHN2PGxrEQj6JFr2jN1qVVhUPj+e2QvU5svp/BD5EZAjRGRlv2g7GShRH/T/0UwjLSsm2q4sMnzn3L7x+/fBLi//USkX48SjCcX4ozu/6oZ3+GfBArszPz42U8Pa2bfHoxhisdok+m84GBLnz8p2H5FTv/f5HfC60N+1A4KX6KhaTPX74vG7cKQnAujQ1vwnSc1T4Zjt8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DS0PR15MB5944.namprd15.prod.outlook.com (2603:10b6:8:124::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Tue, 6 Aug
 2024 19:35:07 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 19:35:07 +0000
From: Song Liu <songliubraving@meta.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index: AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYA=
Date: Tue, 6 Aug 2024 19:35:07 +0000
Message-ID: <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
In-Reply-To: <20240806144426.00ed349f@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|DS0PR15MB5944:EE_
x-ms-office365-filtering-correlation-id: 4238a5a6-f0df-4fcc-30b8-08dcb64ee0f7
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?R280UmZGZzJqYzZlWUM2YnhiclE3ckxGZk1VdFZaRUQxbWptK01HaDE1ZVll?=
 =?utf-8?B?bTJ6WlVFRm9RZGZ5L0RBdjk5TjBTWlFydWJaVkRvMGVReHptQ1JwTVpVSEpZ?=
 =?utf-8?B?NmMxRUhMZGtFMzNOU1Z2REJ6d25PclVsb3B6dHArOUtYdjV1anhnaSt3VkhQ?=
 =?utf-8?B?Vyt4T0JVaVh2a2h0cGpvRnZ4TnAwNG5TMFppZ1B4d1JhejRRTkhENG5nZFZ1?=
 =?utf-8?B?YmVGc2dLUXdwR0FkTXBNSUhhS0xhYmYxWVJ2ekZRZWs1TlFmOVJ0RTFVVXFm?=
 =?utf-8?B?MDk0V25LWm1qR2FjRVNsdit6clYvaGZHR1JzZUxiUFNMa3Q2SGhGQ3dvS0l5?=
 =?utf-8?B?d2pxQ0NIaTVLOXppWGpydXdyNktmZDhvME5UQXZYcFczMEhYNHlGSzhrc1ZE?=
 =?utf-8?B?eDkxZkJXQ096VW1sd1dXVUdMSHVZK3EzVy9mOUtTN2dqcG1DdGphbzIxL2xF?=
 =?utf-8?B?dTQ1WHVaWWN5cEZTNEhlUDdZTWFqSWtpOUoyTTN3cEYxWWNsWFhXYlhqZ21Z?=
 =?utf-8?B?S0o3OExqMDlraVBMc0FKZ2xIRUFlcCswSmlLdUVwd1BMVTFKUkxHUE42bXNM?=
 =?utf-8?B?WXFMMEdjd2xiN3V6UlNoOCtobnZTdE5qOXZrKzFQNFZWdWJQalo2clUrWXJJ?=
 =?utf-8?B?NnpkL2xqYm1RRkl2T0N0ZStUMEZYd2ExNDZ3eGNnZWVETWRQUkJHL2F1UHJH?=
 =?utf-8?B?TUhUWGZXbHZkTHU1Mkc3TFgwN0xLTFc2akc3cjRRYXRFSVNWL1VCRjB3L3lQ?=
 =?utf-8?B?YjhoSk9rc3JQTjlqZ0E2cWZYQUhSMXJZc0RKcnR4NnNDQ3BqaEpBeXN5K0tl?=
 =?utf-8?B?azdHSlgrWXNMWFlIRWJCVHNZU2hKYXQ2TUlNSFFXTXdYOXZRQ0xYRzlYZzlM?=
 =?utf-8?B?U0JhTVR6VGxlU2JhY3RBMEtYcDdDR1FoWmlwNDZWSFlvZk1nZ2kybEFBTGFT?=
 =?utf-8?B?WkRGZVUxQzJnSTVnbnFsZFJnMUN2WEpna3VVUjZBdnhxRE9URFhYS1ZLbk1R?=
 =?utf-8?B?Qk9tSEtxS1NzclcweTRSaUFjblJQNEdndWl5NVVWR2t4cU1FMUJsdkh0THNp?=
 =?utf-8?B?eHA3TmlSOWthazNjTERaaWwzVHJxcEFxaCt3UHpaK3RnaEZpdUZOb1Babkxi?=
 =?utf-8?B?UXRWV2RueWtlYWZ0VE9UakliQ3F0Tzlrd0wyK1cxVldwNTVPMFczVkUvcUtr?=
 =?utf-8?B?VnYrMGJZYjZZdHpZNVU5TkFrUWt4V1RPYklwOWJ0aFgxaHd0cFI4ZnJnM3RE?=
 =?utf-8?B?cnZRbDVpRzV5RXNjZ3ExblJBWTlOUWdFVUE3TU1LcHlRcnNRVEthV05FMnJK?=
 =?utf-8?B?Ym5CZGlqSTJqeVF3NFRZYzZjS0pZSU02YjMzUXkvbFNxbGtpRDNQVGpVU0hx?=
 =?utf-8?B?L3R4Y1hPNS9PT1h0WFg3QVJRVHVDZk1mVVMrL2NORXlqVUNIS2dzZ0hTUTVo?=
 =?utf-8?B?dTdPaEIwdG9SakpocnhnclMxbko1ZFpYV3RjVTNXY2psSVAySDRrajZRcit6?=
 =?utf-8?B?dlpEekVnSXhPclRaa2ZibXhvNWU2aE1JU0JzS1QxSXpQTmFkNk1CT2hzT1Bt?=
 =?utf-8?B?UFNVN2h6QUd5UTBsaU1XQmNpVUFjUlg3YjlXZ0RjeXNRd2I4UVBUQ09yY0hp?=
 =?utf-8?B?RjR1YWluTCt0VStEZmdsRFhvRzRVbGhnTC9LdXNLSW5BOFJLcWRIRGUxdlFl?=
 =?utf-8?B?Y2ZBMk4wY09qRUJGeTg2Zkt5ZFNySVAwUTh1M1o2MVdxOTdiVGdhdU15MFl6?=
 =?utf-8?B?Z0l1SThGaHppYmJxOVpXYm5zY0Y1VjdUK3Z2R2ZQemVrNVJmUDhqdVJuUFNp?=
 =?utf-8?B?aitxZGsrWkpoeGlQTXU4b0lseVZQaDdRZW04aW96NWxxN3hBMEMyT2lVZE14?=
 =?utf-8?B?Ry9iYmQzY0lkQmpGNmFha0l6R3c0c2dMbUhZRTdZQVc1N0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZXNWTjVnUEVNbDJaeEhsSFVld1ZpNnJPWldqWncrUGZHVGpIZTJhZTNDWTNz?=
 =?utf-8?B?dmRNakN6MHhuT253K0YyYVkyUWJ5MW1KUm1RMFI2bUpBOTAwWVFMMTFTWWJG?=
 =?utf-8?B?a1VVOStTaW9Hall6VXJJZnZoSTdsL09kUGlzT0psWDExb1ZsZnFCM1paRHI5?=
 =?utf-8?B?MmpxYXFKZjlJdElCTEcvQituQmRzN1pwMUE1bUdWVVlGd2pMQUpKNkc2eTBM?=
 =?utf-8?B?bjVPc0lBM0FuOTNLSUVpN2F1aEZtWkxSQ3BKbjFVQkRGUDJlclNTdGlVOFVT?=
 =?utf-8?B?UlVtTVQvUDVUTUg4VHBySm51Rnp0MWhaMHpEc044bXl2UEdrUlpPMFF2VHQw?=
 =?utf-8?B?QllEZWl1c0RJaFFqOEpVeG1Pc1pFREoxRjdZakQ4dTNIWGlUbXhLeTROOVU3?=
 =?utf-8?B?OUhoWkczaFpZbHNSZy9scEtYc1dtaG16QlhhT2IzTWUrNGtYV2dEMDRhc0dw?=
 =?utf-8?B?dzVZL1FadGd6Tkt5YklNd3d5MFo3ay9NTzhmSklOYkpFOEVHeVBSSVBaQmhC?=
 =?utf-8?B?TmZHWGwyVXllcS9EaUV0aGpLMHZmVGJyRURxTVFYVjBBNFpIWE5zb3IzL3ps?=
 =?utf-8?B?bFdUS1gxWWJtNy9QM1VuamIrQUpaM0dkc29QMXQrdGlRekFKNDVIL3NQOGNk?=
 =?utf-8?B?SXhTQmlqeE9Rd0I4Uitnd00reW5USzRFcFpycXJ2Z2ZYMzRONlRwaHIwZXhJ?=
 =?utf-8?B?bzFLSUs4VldUR3hOM3JjMUdobncrTTR4ci9Sa29rbC9naVcrc1ZQY2RTTWtt?=
 =?utf-8?B?MzY1a0wwUmpnSTgvNHc2NmF4a1RPUk1LcjhJRktDMFpXU3h3V0VSb1VycHpI?=
 =?utf-8?B?TmVqRjVyUXdidjJlWFhSQXVQMWcwWG1kYXNPRTIwbG5jVEY1bmV4anRBVTJr?=
 =?utf-8?B?ZCtNVktaMWNQYVBqUlFhcktMSmRTRlBvejA2RUYvLzVqQnVCVWRNSDlhSWxa?=
 =?utf-8?B?aWpJSDdPTXc2SWp4QmZQaDQ2dGpPZFQzc1ZZdzBKbTg4TUhsQmg0KzJTSjlI?=
 =?utf-8?B?L1lPUW95NzZqVmM3YUd2RFg2SmhwaTZyUmJmbU14M2xwcWF2YlFqRTBkZlRP?=
 =?utf-8?B?T2FLZ1F6SnlNWjhzU1BkbTdqYW53UWI3WHZ5N2ZvNnpXeFJqdUNGTGVOdS9B?=
 =?utf-8?B?T25KTG1tVkRxT2g2cHFuVnptdE5RekZ1cXpjTUYvN3Yrb2hsTnVxNmhMS1dv?=
 =?utf-8?B?SnF1c2ZFRkV5RTZTNVdHM0ZjSUNjaHZvOG15ZnR5aUNueno1UTRpVDQvaTRC?=
 =?utf-8?B?T0NOWFh5MUNQd25WZWlsUW9YSUFIREY1cmoxQkswcXg2WGtlYWdxeVJWdGhP?=
 =?utf-8?B?bmxxMG55N29ONWJXWjU2Y3pYcGJUanQ3TjRiclkwUHlBMHZuOHNWci96Vmpa?=
 =?utf-8?B?RXE3QjJ0TXIzT1Zmdkw0aDhud2JRWm1zME4xUUhYRktzbGJFOHgzMTUzZEU5?=
 =?utf-8?B?YmZ1cXI1SlBoTURDWGhlT1k5ZTNOZGt3YS9qK1U4NndxeEJlTGxCRG82MmpV?=
 =?utf-8?B?eE9qQzNkbmUrRnUvdDhOTDhoTmY1YUJkZnUvUnFHUXExYzh3dzNsRDVpUVNY?=
 =?utf-8?B?M3pWcUhhaFFwK1RyRlVCK0FxRUZHNFpNVnVMc1Nuc0MzejBxcmNzNU9tKzl2?=
 =?utf-8?B?ZkVQbS9YUUVRaWkrNHVSZFo4MGlJQkl5K09UakdJWG5Vd1k1Y2hLbW53UlpP?=
 =?utf-8?B?ek1ZZ2QzMnljSnpQNTEybXFSTHdZWmxUVmRqRDBHWGFpSEE1dXAyWWM2U0E0?=
 =?utf-8?B?K2gyOHVaOGtYaXBsbVhEckp4ME9xMW9TWHIrdTZIdmpOOUkzRHpWVEFKRFIy?=
 =?utf-8?B?ZFRmYjYzcEIxa1JGNDVGL0tvck1ZTm1UMXMzaXZCa0RIcFFsTFFOZXNLV1ha?=
 =?utf-8?B?VzNHWmhkUnBBSWVrRjM2YXl5dHdreVpTaDQraGk5MVZWM3YvVjkwMzAwalRk?=
 =?utf-8?B?alJhUjgyOHIxRE9PZDFubHZha2NUZDFsTTh6OXZEOHJzdW9BdENXY3l1dHhO?=
 =?utf-8?B?VUUwSWhLU1NiUEtya25QTUhWa0ZHS1FHK1Z2M2ZXRnBqVno3L3N0dmFPdjdY?=
 =?utf-8?B?anpXcFBUS2RQVHl5dlRJZG0vSHFyOHZUekpxT05tVTZoaXVkTGkzVjRnMFU3?=
 =?utf-8?B?M1ZycG42Q0V5SThVYUMrd3ZjOVh4d1Izci9yV1o1UEZOeHhjVVZTelpFV0Rv?=
 =?utf-8?Q?RLgpv1Q1x08yhQ2ITO3j17wgav/ARiG8YmpH4S6JyoTM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10A86664E1B2C24FAB6C7DD4AF043EB7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 4238a5a6-f0df-4fcc-30b8-08dcb64ee0f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 19:35:07.7630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9VN2yuYHp+fiyQJsVdib4eugyKfAh3CzqzWcpuudfxJS9LPHbBK3waaH1UzT6h5/lEWzgdTiB9To/0J3MFfkSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR15MB5944
X-Proofpoint-GUID: iq_sPFsYw8bXTAS1i7wFVPV0nlcmcY6H
X-Proofpoint-ORIG-GUID: iq_sPFsYw8bXTAS1i7wFVPV0nlcmcY6H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-06_16,2024-08-06_01,2024-05-17_01

SGkgU3RldmVuLA0KDQo+IE9uIEF1ZyA2LCAyMDI0LCBhdCAxMTo0NOKAr0FNLCBTdGV2ZW4gUm9z
dGVkdCA8cm9zdGVkdEBnb29kbWlzLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBGcmksICAyIEF1ZyAy
MDI0IDE0OjA4OjM1IC0wNzAwDQo+IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+IHdyb3RlOg0K
PiANCj4+IFVzZSB0aGUgbmV3IGthbGxzeW1zIEFQSXMgdGhhdCBtYXRjaGVzIHN5bWJvbHMgbmFt
ZSB3aXRoIC5YWFgNCj4+IHN1ZmZpeC4gVGhpcyBhbGxvd3MgdXNlcnNwYWNlIHRvb2xzIHRvIGdl
dCBrcHJvYmVzIG9uIHRoZSBleHBlY3RlZA0KPj4gZnVuY3Rpb24gbmFtZSwgd2hpbGUgdGhlIGFj
dHVhbCBzeW1ib2wgaGFzIGEgLmxsdm0uPGhhc2g+IHN1ZmZpeC4NCj4+IA0KPj4gVGhpcyBvbmx5
IGVmZmVjdHMga2VybmVsIGNvbXBpbGUgd2l0aCBDT05GSUdfTFRPX0NMQU5HLg0KPj4gDQo+PiBT
aWduZWQtb2ZmLWJ5OiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiBrZXJu
ZWwva3Byb2Jlcy5jICAgICAgICAgICAgfCAgNiArKysrKy0NCj4+IGtlcm5lbC90cmFjZS90cmFj
ZV9rcHJvYmUuYyB8IDExICsrKysrKysrKystDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9rZXJuZWwva3By
b2Jlcy5jIGIva2VybmVsL2twcm9iZXMuYw0KPj4gaW5kZXggZTg1ZGUzN2Q5ZTFlLi45OTEwMjI4
M2IwNzYgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwva3Byb2Jlcy5jDQo+PiArKysgYi9rZXJuZWwv
a3Byb2Jlcy5jDQo+PiBAQCAtNzAsNyArNzAsMTEgQEAgc3RhdGljIERFRklORV9QRVJfQ1BVKHN0
cnVjdCBrcHJvYmUgKiwga3Byb2JlX2luc3RhbmNlKTsNCj4+IGtwcm9iZV9vcGNvZGVfdCAqIF9f
d2VhayBrcHJvYmVfbG9va3VwX25hbWUoY29uc3QgY2hhciAqbmFtZSwNCj4+IHVuc2lnbmVkIGlu
dCBfX3VudXNlZCkNCj4+IHsNCj4+IC0gcmV0dXJuICgoa3Byb2JlX29wY29kZV90ICopKGthbGxz
eW1zX2xvb2t1cF9uYW1lKG5hbWUpKSk7DQo+PiArIHVuc2lnbmVkIGxvbmcgYWRkciA9IGthbGxz
eW1zX2xvb2t1cF9uYW1lKG5hbWUpOw0KPj4gKw0KPj4gKyBpZiAoSVNfRU5BQkxFRChDT05GSUdf
TFRPX0NMQU5HKSAmJiAhYWRkcikNCj4+ICsgYWRkciA9IGthbGxzeW1zX2xvb2t1cF9uYW1lX3dp
dGhvdXRfc3VmZml4KG5hbWUpOw0KPj4gKyByZXR1cm4gKChrcHJvYmVfb3Bjb2RlX3QgKikoYWRk
cikpOw0KPj4gfQ0KPj4gDQo+PiAvKg0KPj4gZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFj
ZV9rcHJvYmUuYyBiL2tlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYw0KPj4gaW5kZXggNjFhNmRh
ODA4MjAzLi5kMmFkMGM1NjFjODMgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwvdHJhY2UvdHJhY2Vf
a3Byb2JlLmMNCj4+ICsrKyBiL2tlcm5lbC90cmFjZS90cmFjZV9rcHJvYmUuYw0KPj4gQEAgLTIw
Myw2ICsyMDMsMTAgQEAgdW5zaWduZWQgbG9uZyB0cmFjZV9rcHJvYmVfYWRkcmVzcyhzdHJ1Y3Qg
dHJhY2Vfa3Byb2JlICp0aykNCj4+IGlmICh0ay0+c3ltYm9sKSB7DQo+PiBhZGRyID0gKHVuc2ln
bmVkIGxvbmcpDQo+PiBrYWxsc3ltc19sb29rdXBfbmFtZSh0cmFjZV9rcHJvYmVfc3ltYm9sKHRr
KSk7DQo+PiArDQo+PiArIGlmIChJU19FTkFCTEVEKENPTkZJR19MVE9fQ0xBTkcpICYmICFhZGRy
KQ0KPj4gKyBhZGRyID0ga2FsbHN5bXNfbG9va3VwX25hbWVfd2l0aG91dF9zdWZmaXgodHJhY2Vf
a3Byb2JlX3N5bWJvbCh0aykpOw0KPj4gKw0KPiANCj4gU28geW91IGRvIHRoZSBsb29rdXAgdHdp
Y2UgaWYgdGhpcyBpcyBlbmFibGVkPw0KPiANCj4gV2h5IG5vdCBqdXN0IHVzZSAia2FsbHN5bXNf
bG9va3VwX25hbWVfd2l0aG91dF9zdWZmaXgoKSIgdGhlIGVudGlyZSB0aW1lLA0KPiBhbmQgaXQg
c2hvdWxkIHdvcmsganVzdCB0aGUgc2FtZSBhcyAia2FsbHN5bXNfbG9va3VwX25hbWUoKSIgaWYg
aXQncyBub3QNCj4gbmVlZGVkPw0KDQpXZSBzdGlsbCB3YW50IHRvIGdpdmUgcHJpb3JpdHkgdG8g
ZnVsbCBtYXRjaC4gRm9yIGV4YW1wbGUsIHdlIGhhdmU6DQoNCltyb290QH5dIyBncmVwIGNfbmV4
dCAvcHJvYy9rYWxsc3ltcw0KZmZmZmZmZmY4MTQxOWRjMCB0IGNfbmV4dC5sbHZtLjc1Njc4ODg0
MTE3MzEzMTMzNDMNCmZmZmZmZmZmODE2ODA2MDAgdCBjX25leHQNCmZmZmZmZmZmODE4NTQzODAg
dCBjX25leHQubGx2bS4xNDMzNzg0NDgwMzc1MjEzOTQ2MQ0KDQpJZiB0aGUgZ29hbCBpcyB0byBl
eHBsaWNpdGx5IHRyYWNlIGNfbmV4dC5sbHZtLjc1Njc4ODg0MTE3MzEzMTMzNDMsIHRoZQ0KdXNl
ciBjYW4gcHJvdmlkZSB0aGUgZnVsbCBuYW1lLiBJZiB3ZSBhbHdheXMgbWF0Y2ggX3dpdGhvdXRf
c3VmZml4LCBhbGwNCm9mIHRoZSAzIHdpbGwgbWF0Y2ggdG8gdGhlIGZpcnN0IG9uZS4gDQoNCkRv
ZXMgdGhpcyBtYWtlIHNlbnNlPw0KDQpUaGFua3MsDQpTb25nDQoNCg0K

