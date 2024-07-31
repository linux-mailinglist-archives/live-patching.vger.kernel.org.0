Return-Path: <live-patching+bounces-423-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A36942406
	for <lists+live-patching@lfdr.de>; Wed, 31 Jul 2024 03:00:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 855FB2862EB
	for <lists+live-patching@lfdr.de>; Wed, 31 Jul 2024 01:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 477404C76;
	Wed, 31 Jul 2024 01:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="OQsR7NdJ"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8570838C;
	Wed, 31 Jul 2024 01:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722387641; cv=fail; b=ichxCi9tq7WG0uJqRWJMUllHkshztte8k712SjPDu3MO7ELjK0VKq+zb1wt0cqLzrnaJ7eJlzb8ZW22OJg8kGezB1kwrwmpBIvVKyR9tXLSw8Yvt+n6D983lz7aMb4FK1djDFK8Wt0VLOnF18tomHjrDzljkTcFxTMWf+gea/qw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722387641; c=relaxed/simple;
	bh=J/hsf/EEMJUwc8uW3/G+FVyTH7ziST9ud4kBPQefrgM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j9UakCZ0tIdM6B0ubPW1LCRSRzqQiI+/Zy+lJv3AvcFuLFW0ATqkkG9UoJF4ebkO6E6sNDB9E2bJznhaZUSEKmEZ9Mgy62rRHvKvJSordykni6w9sHpBUO5mnoFurHBJZl8CtLxJiORM5Tnt4TvYo0prziGIlyN5XAcuZ5ULqBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=OQsR7NdJ; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UNppQm014604;
	Tue, 30 Jul 2024 18:00:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=J/hsf/EEMJUwc8uW3/G+FVyTH7ziST9ud4kBPQefrgM
	=; b=OQsR7NdJyvafjcyMYC5jTU1NcU1/qRcd1diPz14oMliS3EzCbDpXVUIBX1I
	NHh4PZrZ1xXdWKO4EarUspVf5KHqEQoNZcn4a3yt4UuwGNsWeg9vSChSZSqayp/7
	/ROIsJzkwfRBnC+XW05i7Eaz+J9nXwcrWZI1OO9PO1ATdZlo9DCs6zPgwAOHK64P
	qbCx7k4/b8zGbyCFCm0nyhZPFPeVSroWG/w91HewN+kdzdVHlMptV3lu3LSjA+8M
	kUkiKWN6AIvb93jK9HpBqu1CwJ+rH3UvD4njx3wBbN/1luxZZsKFFoToDAebVtuF
	/XEzeMyjxaT8Ii1QbFqA0sGXQug==
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40qa6brabm-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 18:00:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rN5ciefAdUzSZ6/BIzfrPXCr2UXcKHBrNYwZqPOBfCL+P+bFK5HxhPnB1/m9CbP0HO5FGR6qaGMGhVjKNP0TsgDsImNQ//n10YfcVUJCv/p+YPiWeF451hfDyVGxcg6eUlZO5T1lxmUm9XQErXQdiRNM4ruy1Yb5sKMSqpbwhMG1xsfnKfyAx24xufyMQF97DfnCTR89qpmgetZkbqoXo1BFB6phXFbmul7QrM9UJ4JEzNY1sl+ZwJcjwNPDrXsOtfZUUUS+HgkNybmFb+5pVPWdMbv3BxffQsbSCpZSPpPQAu9yOgteNP+YQukgpFYowDUKdtFwkFoscOtB3k9TRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/hsf/EEMJUwc8uW3/G+FVyTH7ziST9ud4kBPQefrgM=;
 b=GArcHGEukONZivv7pFQm5cil8DuUkIlNwlWeiNQLyWrzkMQIZUYtiLnCogFm0ENxyZx0V78Fc01RiqaB/LSURGVtRl40sVc7CaDB2XaJ3jqf//o48WllucG9VOO1cd1NRHCvsvivSWRNkb4BrbOotj5KChufEg36zF0dHfTCDoUz4hE+9ogb6kL8qMS2qhm1FfWZ2s10bx+pMjs7hE9+74AoriNbsYgFgkWrK6xL8oaqnfq3LuoK7SnazJlyGKbFn3KBH65nU2N8g4NQmhAcbhI9J9toHPsCz3N31r7c6WlMld4G4zUXrqn8gL3+4ORWkzaraGa0Kx5jfZjVAN2mrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4152.namprd15.prod.outlook.com (2603:10b6:510:28::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 31 Jul
 2024 01:00:35 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.016; Wed, 31 Jul 2024
 01:00:34 +0000
From: Song Liu <songliubraving@meta.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
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
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Topic: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Index: AQHa4hsdZBHaq1mnRkygDON43y0YhLIPPWoAgADIbAA=
Date: Wed, 31 Jul 2024 01:00:34 +0000
Message-ID: <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
 <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
In-Reply-To: <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4152:EE_
x-ms-office365-filtering-correlation-id: 02dd6763-5a4b-499b-df4c-08dcb0fc2f01
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?TTJ0YlNEanFMTEo2d0lZNnJTQXI0QThWcDd3WU9OM0RUZ00ybWQxWDlXRUh5?=
 =?utf-8?B?WDk4Ry9NSjNZMEg0SjhobkhRUURHdEQ0c25KVmlIKzkwV2ErbmNMM1BCS1I5?=
 =?utf-8?B?RExkVHVsQ3BBTUpTckRVZW9ZdjBpb3YwVC8zVjFvVzlBMHF3TlZ3bm50TjZT?=
 =?utf-8?B?S1RLUktBZ0Zxa1YwUjVQZnJNeVVTVGZkYkx2eW1yc3BWckI4QzR1ZkJFdTdr?=
 =?utf-8?B?ai9sQmFuTi9rd0tjUzd3cE9MSTNia084aVZWVWJpK0NoaHQzUU9NdnlGR0NZ?=
 =?utf-8?B?RzFOd2cyUVB3ZnU5czFieHpXRFJpRXVIL1NFOVVTMkdWRVpRV1ZQQ01lckhl?=
 =?utf-8?B?OEtFQ2RuSENNcFpCTk1CZzhGWXAzMFZZZFlROFF2djNVelRydTBtcms0c21I?=
 =?utf-8?B?cFFMRWRnVFduR2NuSlBaOWd1aTdUSW5pWmVCV1dvN1lGNVpMajcrQWtRbXNi?=
 =?utf-8?B?TWpXZ1p1dnlScDNKMjBYaHZOSWRpeDJaSWFrdlA4ODdZYmlpM2R1WXd1czRs?=
 =?utf-8?B?MjVPdDJjYTJhTTk4amFHb2pwSDJMZjhkRVgrSUh3SEY2WnA3RzNxVjdoR1k4?=
 =?utf-8?B?cTdCZ1ppV1g1SHlMNmQ0cEUxbmVsVC9hYll3UnRpRVNGWmNyZUhMMFREdWRM?=
 =?utf-8?B?QTZ0a0lYVFBhMU5aeGYvN0ZPbEFNaDBFQk5TQVI0U2FleVJsUlNLVnFIdGw4?=
 =?utf-8?B?T3pEemJDdU9wZVhzMHM1Z0IvWDJtV2hQWWpuTGdyT2NmaEJmNUZlSWdxUDA1?=
 =?utf-8?B?dTRtY1pkWHdFZ2dXd3E0Mk1JM2NqNFNrNy9pWWpyWFhDZWIxbWZJdC91L0J2?=
 =?utf-8?B?UWdTWWZpa2pzTXFvU3JSU29ZcUEzcWtPTjc5aGJ3K280UzBXRmY5Y0ZoMWsy?=
 =?utf-8?B?VzJ5RFBldHBBY29mWjgxazJ6M1M5dURyZklDazZiL2lFVThmUCtTOVpZYzkr?=
 =?utf-8?B?M1A0WXl0VFBTT3p2V2JvRGFTbmVRM2V4VmZwcVlzL1dTWE1pcVh6SjF6bjRk?=
 =?utf-8?B?Z3RDOENGN2pEc2VPcVg4S1RyaDErTWJRQlQ3RitLdTd4M1dmZ0dMQnB6UGdl?=
 =?utf-8?B?N1VscWorNVZJU3VZNko4VEtpZkhKbHg0WURheUVLeDVJU3BYNkFaQkhFbXR6?=
 =?utf-8?B?eXc2L2d1VkVjNEErTExON0N5dGdvS0xIV0lYVFBGeFdNTkg2NXA0NGZLdWMv?=
 =?utf-8?B?S2JMR2hRbDc3USsyRHF6dUdudi8xc1NCZk83YmhlSnVTT0l1MU5PeUlMRjVs?=
 =?utf-8?B?dG9lTlpWaVFOVWZQUFpJYThYOGZEMld5NFhKU0NmNnkzY3pRcHZNTmVTZ2p1?=
 =?utf-8?B?SlNvaHZLVkFLUytVRkdRcGZmazdpSlAzaHEvM3UxOXVzR3k2dnRWTURUMktK?=
 =?utf-8?B?VkxUSTRrSC9xcTRmTW5LUmJWUkpNL0w0MXEvS3VWLzVJcDJYcVJJbGxXOTRm?=
 =?utf-8?B?L1RJdDNnQW5IVk1JV3NjL09kTis1NzRZLzU3Q1NUYVg0N2tKQVEvcU9TSzJJ?=
 =?utf-8?B?Rzd3dXBFc2hpZm1ZSjgrVXVvQ0NXMG5KakJLUnBKcmFBY0FSOEx6OEFBZ3M1?=
 =?utf-8?B?TGwxM2RRYjd0K0Q0b1JvRUxwaEdtWTZDN1NjK1lkK3AzVjAwdW1UOFUwV1Q0?=
 =?utf-8?B?Y2FtSjNaM3lic1YyVjVqNUdPUjRsdHo1RFBJbDVnK2lJSnJ6aVgrQzlxTlFN?=
 =?utf-8?B?Sys2b1c0SjBNRTVCU1FWNXpLVkJNTXZxL2JYUkFtcnljcUlHWkZWbExlUTh3?=
 =?utf-8?B?RkwvazYveUJRS3JXUnVhb2RTQWQyWkc2RUJyZ0I3SWEyQ2kwdHlUK2xEcnhE?=
 =?utf-8?B?b3IxS1p0ZUlNdFdmQ2JCN0RoUWFUSXpOMmk1TzRaUUFRM1ZHT3NSRHZQSDh5?=
 =?utf-8?B?YmVNZHpIaEdVSzRRU2k5UGY0UTBBdk1SZW0wakFzb3dCTmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TTV5T3BnOG9NZEZldGNMZzBKRU83ZzluUGRIMUdNSisveWJVd3kwczJzWGNB?=
 =?utf-8?B?dWxzZmtmeCs4NnJZSHBwVy9PdXFuZWc0dUZGZnArR0tIcFNVWDduMDJnUnJx?=
 =?utf-8?B?ZGlLbVU1WXZUTURUc0tzRks3cXNRSWtsdjR4OGsvMVNTY2FRWXBKaEZyVWFV?=
 =?utf-8?B?anRadFBrMWVvMmdabGJOQ01yYkJKbmxqanZ3Uit3d2dpeWlkUldoOUQ3SVlC?=
 =?utf-8?B?TzFpWkRHbDNMR0ZUUFljclJiOTdEZ28zejFwc0tpZDlnYXlZRmllR3BSVkFF?=
 =?utf-8?B?SHdMazhJSXpWc0U2L05PeVhVWldGSDRFR1FOdzA4amw0T3lORy9JQytrbEJw?=
 =?utf-8?B?dmR6MjJRZG1rcmcrb0xZYzNoMlhVaXBqUkg3VHZWZ3l5MmdyTUUzaGlDOUNq?=
 =?utf-8?B?UHhvQXFRNmNxQ1JOT2hQLy9YeExzZmtzT3EzWmVNaVI0cG1ZSXJ5b2NScWhz?=
 =?utf-8?B?ZzhpSUlCYS9zTnBxalowMWRISTVDWmpDcWN3ZnpXdWdHNjJEQWl6MG8yV2Rv?=
 =?utf-8?B?OXUxZ2JmODFIUEJBME9FRjk0VEI4SHdLeDQvU2FxUHFMRU5rWjAzNzZLVjZM?=
 =?utf-8?B?VDkxWnFZbFdRNDlIN2lhNGxpcUovd2JNT29TUGNObHJsNXczZjFzdVVKS2xa?=
 =?utf-8?B?Qk5IZ2xZbVdqTU5tMGc4Nk9qc2xoekI5ZWlXWUEvRXo2QVJRUnZwSXFkYWQ0?=
 =?utf-8?B?VGlCeTc4WFpXbWRUUis1c04rdjZjZSsyN2h1VE9NL3luZmtaYysvejFKbjVj?=
 =?utf-8?B?djJUOW1kRzBEY3g4aW8xLzlWOUkxWUVPSThVOXBGM0UySk9Ua0FRTTloamVi?=
 =?utf-8?B?M3lFamlmSFBlaGVac2ZOdkNMVzYxVzJaWHdmZnBldlFLdmZOUkJPZE9XeWRN?=
 =?utf-8?B?Mll0ZHZwRHh0ZGdqcDc0eFIwWmRvOXVKQm1hMHc5S1l6b3U3NDJxU1B1Q3Vs?=
 =?utf-8?B?QnRMYTBYcDdtNVl1K2RYb1F3ODNlNXBNMkorMTBmL3IwUTBXY3pFaWVSb3VB?=
 =?utf-8?B?dStIQ1o2ZkpDaU5SR3B4NW13dElabFoyOWFiS1NLdll5VVlDZEdLQ1kxZEtD?=
 =?utf-8?B?SDA0ajhYVkwwM0JBdjZOZ0UyRUJnUEVhb2dhdXo0ZlRQdHBXUUFiZCtjUU5U?=
 =?utf-8?B?bGkwWERlbEpvRElXWFFzcTVwcVByaFVQd1FpMTRsMDBBWEJYUXdJb1g2UVND?=
 =?utf-8?B?emJvN2lGTXZLaTk4Z1IzcFF2TnptYzBhdlhtZ1ZYQi9kU0xQeEVKallpcXh0?=
 =?utf-8?B?N2xIUWpGZGo4dFZuTGppVlBNbXVpa2srNHNLT1UxL2RZWFNaLy8xNGRSWVpN?=
 =?utf-8?B?M3U1QUVKaWQvYjQ2U2gzZDJZVDY2MUZrd1dzdnh3K2xxbzZPL0lwcmpqaGg0?=
 =?utf-8?B?K2s5ZDdSKy9uMkdaVTVWRm9GYTgxRFZQWGZFTFFwWHZYZUZJeXZqQjNVZklm?=
 =?utf-8?B?ZnpOdWhBKy9ZYVdKcEpGZ0U3cGR6bFhIK1MxL0F6cjFKVWoxUVdEYXBKbU5C?=
 =?utf-8?B?YmNsc0hGLzRldmR6Wi9VMTZUZkxIV09TNWY2TXNOYXk5ZzV6blhOcm9udU1x?=
 =?utf-8?B?blp1czFabkx4bHUxRFJTelU0UVNOeEhKWXp2ZFFhWjZVaFFTRHVvVVFPQVor?=
 =?utf-8?B?NU1CZklaWWJxZEpDaHZwd3k0dEFIOUhlQmk5aGtsNVlhQkxQN3pUaHpMU2Qr?=
 =?utf-8?B?MklsUlJld3JYTy9henRVSDQ0eWM1c09UUndwbEMzd3o3OGJ5MXlyUUg4dDVS?=
 =?utf-8?B?N2lObzc3WXFWK04wZDNYaGZCNjNjWThiOUZJc0VZVzdTcWw2b0REeldkeGl5?=
 =?utf-8?B?VER4SmYyUndRUmNBZ0ZHYTBSckhCL0MxSllVUnExY0ZYTlJwM2lkc0dNWU1G?=
 =?utf-8?B?UUd3aEdHeThCbExIcFhNdVFnYWIvOUdWT2JQYXpDWklnOS8vT3RsUTlWdXYy?=
 =?utf-8?B?ODFUOVplWVJCQlFaaVpUTUlwNVp3U2k1RGhQNVM3d1ZKZWRscnpUY1hSaFVl?=
 =?utf-8?B?bmsxUWtubDcwRi9BRDFHVTcweXZ1M3hOU2NCQjhxYmpFWFZ0S3A0L1RVSFR6?=
 =?utf-8?B?aXo1TlFyS3VKTm1oTCtPc2NVd1UyN0RqcjZZMTBsLzdEWitRdHRlY3NOb1My?=
 =?utf-8?B?cmxVMmp2U3drbURJNHVndkprRFJucnl6SkxLQ2w3emxtK2lnNHE1TlFaN2pF?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4017E552D03F5F43BE5C5D4EFC2694CA@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 02dd6763-5a4b-499b-df4c-08dcb0fc2f01
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 01:00:34.6197
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dT7i9rcJvN1qYMCw1nS0cpOdQH1BIPMVN8wjVUD8bCdV3uWxeOooYzFo4y2tqs6KLitNUhcNBm7NYYp99DTurA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4152
X-Proofpoint-ORIG-GUID: -GuYkCoJ9elqCmtakcKDsjmkHSZ_ytvz
X-Proofpoint-GUID: -GuYkCoJ9elqCmtakcKDsjmkHSZ_ytvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_21,2024-07-30_01,2024-05-17_01

SGkgTWFzYW1pLCANCg0KPiBPbiBKdWwgMzAsIDIwMjQsIGF0IDY6MDPigK9BTSwgTWFzYW1pIEhp
cmFtYXRzdSA8bWhpcmFtYXRAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBNb24sIDI5IEp1
bCAyMDI0IDE3OjU0OjMyIC0wNzAwDQo+IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+IHdyb3Rl
Og0KPiANCj4+IFdpdGggQ09ORklHX0xUT19DTEFORz15LCB0aGUgY29tcGlsZXIgbWF5IGFkZCBz
dWZmaXggdG8gZnVuY3Rpb24gbmFtZXMNCj4+IHRvIGF2b2lkIGR1cGxpY2F0aW9uLiBUaGlzIGNh
dXNlcyBjb25mdXNpb24gd2l0aCB1c2VycyBvZiBrYWxsc3ltcy4NCj4+IE9uIG9uZSBoYW5kLCB1
c2VycyBsaWtlIGxpdmVwYXRjaCBhcmUgcmVxdWlyZWQgdG8gbWF0Y2ggdGhlIHN5bWJvbHMNCj4+
IGV4YWN0bHkuIE9uIHRoZSBvdGhlciBoYW5kLCB1c2VycyBsaWtlIGtwcm9iZSB3b3VsZCBsaWtl
IHRvIG1hdGNoIHRvDQo+PiBvcmlnaW5hbCBmdW5jdGlvbiBuYW1lcy4NCj4+IA0KPj4gU29sdmUg
dGhpcyBieSBzcGxpdHRpbmcga2FsbHN5bXMgQVBJcy4gU3BlY2lmaWNhbGx5LCBleGlzdGluZyBB
UElzIG5vdw0KPj4gc2hvdWxkIG1hdGNoIHRoZSBzeW1ib2xzIGV4YWN0bHkuIEFkZCB0d28gQVBJ
cyB0aGF0IG1hdGNoZXMgdGhlIGZ1bGwNCj4+IHN5bWJvbCwgb3Igb25seSB0aGUgcGFydCB3aXRo
b3V0IC5sbHZtLnN1ZmZpeC4gU3BlY2lmaWNhbGx5LCB0aGUgZm9sbG93aW5nDQo+PiB0d28gQVBJ
cyBhcmUgYWRkZWQ6DQo+PiANCj4+IDEuIGthbGxzeW1zX2xvb2t1cF9uYW1lX29yX3ByZWZpeCgp
DQo+PiAyLiBrYWxsc3ltc19vbl9lYWNoX21hdGNoX3N5bWJvbF9vcl9wcmVmaXgoKQ0KPiANCj4g
U2luY2UgdGhpcyBBUEkgb25seSByZW1vdmVzIHRoZSBzdWZmaXgsICJtYXRjaCBwcmVmaXgiIGlz
IGEgYml0IGNvbmZ1c2luZy4NCj4gKHRoaXMgc291bmRzIGxpa2UgbWF0Y2hpbmcgImZvbyIgd2l0
aCAiZm9vIiBhbmQgImZvb19iYXIiLCBidXQgaW4gcmVhbGl0eSwNCj4gaXQgb25seSBtYXRjaGVz
ICJmb28iIGFuZCAiZm9vLmxsdm0uKiIpDQo+IFdoYXQgYWJvdXQgdGhlIG5hbWUgYmVsb3c/DQo+
IA0KPiBrYWxsc3ltc19sb29rdXBfbmFtZV93aXRob3V0X3N1ZmZpeCgpDQo+IGthbGxzeW1zX29u
X2VhY2hfbWF0Y2hfc3ltYm9sX3dpdGhvdXRfc3VmZml4KCkNCg0KSSBhbSBvcGVuIHRvIG5hbWUg
c3VnZ2VzdGlvbnMuIEkgbmFtZWQgaXQgYXMgeHggb3IgcHJlZml4IHRvIGhpZ2hsaWdodA0KdGhh
dCB0aGVzZSB0d28gQVBJcyB3aWxsIHRyeSBtYXRjaCBmdWxsIG5hbWUgZmlyc3QsIGFuZCB0aGV5
IG9ubHkgbWF0Y2gNCnRoZSBzeW1ib2wgd2l0aG91dCBzdWZmaXggd2hlbiB0aGVyZSBpcyBubyBm
dWxsIG5hbWUgbWF0Y2guIA0KDQpNYXliZSB3ZSBjYW4gY2FsbCB0aGVtOiANCi0ga2FsbHN5bXNf
bG9va3VwX25hbWVfb3Jfd2l0aG91dF9zdWZmaXgoKQ0KLSBrYWxsc3ltc19vbl9lYWNoX21hdGNo
X3N5bWJvbF9vcl93aXRob3V0X3N1ZmZpeCgpDQoNCkFnYWluLCBJIGFtIG9wZW4gdG8gYW55IG5h
bWUgc2VsZWN0aW9ucyBoZXJlLiANCg0KPiANCj4+IA0KPj4gVGhlc2UgQVBJcyB3aWxsIGJlIHVz
ZWQgYnkga3Byb2JlLg0KPiANCj4gTm8gb3RoZXIgdXNlciBuZWVkIHRoaXM/DQoNCkFGQUNJVCwg
a3Byb2JlIGlzIHRoZSBvbmx5IHVzZSBjYXNlIGhlcmUuIFNhbWksIHBsZWFzZSBjb3JyZWN0IA0K
bWUgaWYgSSBtaXNzZWQgYW55IHVzZXJzLiANCg0KDQpNb3JlIHRob3VnaHRzIG9uIHRoaXM6IA0K
DQpJIGFjdHVhbGx5IGhvcGUgd2UgZG9uJ3QgbmVlZCB0aGVzZSB0d28gbmV3IEFQSXMsIGFzIHRo
ZXkgYXJlIA0KY29uZnVzaW5nLiBNb2Rlcm4gY29tcGlsZXJzIGNhbiBkbyBtYW55IHRoaW5ncyB0
byB0aGUgY29kZSANCihpbmxpbmluZywgZXRjLikuIFNvIHdoZW4gd2UgYXJlIHRyYWNpbmcgYSBm
dW5jdGlvbiwgd2UgYXJlIG5vdCANCnJlYWxseSB0cmFjaW5nICJmdW5jdGlvbiBpbiB0aGUgc291
cmNlIGNvZGUiLiBJbnN0ZWFkLCB3ZSBhcmUgDQp0cmFjaW5nICJmdW5jdGlvbiBpbiB0aGUgYmlu
YXJ5Ii4gSWYgYSBmdW5jdGlvbiBpcyBpbmxpbmVkLCBpdCANCndpbGwgbm90IHNob3cgdXAgaW4g
dGhlIGJpbmFyeS4gSWYgYSBmdW5jdGlvbiBpcyBfcGFydGlhbGx5XyANCmlubGluZWQgKGlubGlu
ZWQgYnkgc29tZSBjYWxsZXJzLCBidXQgbm90IGJ5IG90aGVycyksIGl0IHdpbGwgDQpzaG93IHVw
IGluIHRoZSBiaW5hcnksIGJ1dCB3ZSB3b24ndCBiZSB0cmFjaW5nIGl0IGFzIGl0IGFwcGVhcnMN
CmluIHRoZSBzb3VyY2UgY29kZS4gVGhlcmVmb3JlLCB0cmFjaW5nIGZ1bmN0aW9ucyBieSB0aGVp
ciBuYW1lcyANCmluIHRoZSBzb3VyY2UgY29kZSBvbmx5IHdvcmtzIHVuZGVyIGNlcnRhaW4gYXNz
dW1wdGlvbnMuIEFuZCANCnRoZXNlIGFzc3VtcHRpb25zIG1heSBub3QgaG9sZCB3aXRoIG1vZGVy
biBjb21waWxlcnMuIElkZWFsbHksIA0KSSB0aGluayB3ZSBjYW5ub3QgcHJvbWlzZSB0aGUgdXNl
ciBjYW4gdXNlIG5hbWUgInBpbmdfdGFibGUiIHRvDQp0cmFjZSBmdW5jdGlvbiAicGluZ190YWJs
ZS5sbHZtLjE1Mzk0OTIyNTc2NTg5MTI3MDE4Ig0KDQpEb2VzIHRoaXMgbWFrZSBzZW5zZT8NCg0K
VGhhbmtzLA0KU29uZw0KDQoNClsuLi5d

