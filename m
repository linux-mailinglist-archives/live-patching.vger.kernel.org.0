Return-Path: <live-patching+bounces-488-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB952950F17
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 23:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD7B51C24402
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 21:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7BE43155;
	Tue, 13 Aug 2024 21:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="O45gVDKt"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15181EA84;
	Tue, 13 Aug 2024 21:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723584055; cv=fail; b=l6/LOAGm0MU0PsUfHtY6mQ8PqPU0AlbZAsacWsFGOJXGxuhQBDp73LRqcE7GU3sI5Z1zKFfO8LTg8sIBO+6w2fpFyB88UmAfU/3vXZB2OllrVhebpi72vBco8lKIJ6JJDEUknOKKk08RlCaqQt5MpFdM3/tlME6EBErKOhgA/Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723584055; c=relaxed/simple;
	bh=H93USbJtCg4ntqfnT3X+Cw5/yDmiyIexe+G06xNzMQ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lBMXH444UhMVDpJWj2pdQh/r0/m19O/BJHqhU8qJcTP+TgbEXVzmaPwKCR1q7O30eqP8e0NUirP57YZ5DIjLKbyfkFiQw5RBSN8V9VqDT2ZIo4FxOsxScQVfy9VkKcwRIG609Hi1ZTeeeBRHJ+akY0mHuYLMvh/ytZed2/DKRSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=O45gVDKt; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47DLE3DC003112;
	Tue, 13 Aug 2024 14:20:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=H93USbJtCg4ntqfnT3X+Cw5/yDmiyIexe+G06xNzMQ4
	=; b=O45gVDKtPOVJTtJXUrVC3pMbKweOoBi40kOqHMwfywGjxkRtfvyomjMtwuU
	Ydakg+581i42+7kbXpGvj8DpJdY7rPhG01X+p4DW7FSAmiUBrKIzQuCnS0q4kTFH
	fOIesT00Yqn7NvL4Md/ProxIb56wsUK18+Xb330AcyjhwXNp+r4Vhy/RtLy8Y7x1
	9bIxPGapy2U2viooagi+1Gn31OBE9ErnoeuYXLGTi4vthR/cOGBUoLPFGfRdSx3C
	pLpARaxfXbAAVR5hDsD0AvetAmQuohfN0cdWZl+GEeaalk6256ccc/H1oHsK3iDf
	2LVimVFtiIZmSfPxp0+eq52JG0Q==
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 410820uax9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Aug 2024 14:20:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xGtenrpSmdLju/RA+hhX7ARyiQa309fRkGkT/BrgS4ncSkvYV/2EPrK2hJj9ZzOm6xQC9o/X/i8blnBqORbMcDNd2PEKGQnVmEJcBwKg/qsJZh6i+slbQVv+puDmO0yCqGcpRn5FWuj0mdfazh1k31nnkgyETJTf3biHLANHXOVXvYV1Se39PkkzoXJ9qTKdxpXUeApbbFBSJhRI8BNl6Is92WtcEUYLMJF7JWbEWnySATqjDWGkKt57KsEzCgvTcbTeG/u1+h1G+0yR3OcqsmBgI+DSkrvy85YCB7ZiljVccgB3KoWHfOKplKSRFW8nTpMR2j/EucdYRb6LgUytbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H93USbJtCg4ntqfnT3X+Cw5/yDmiyIexe+G06xNzMQ4=;
 b=fbt4PM2r/lFMaaS8608X4NOx38HdF92zcL2I41t3MXSAYM0X+GBW19n91w57k0QbFwtvJtzgvyjiIPX4srAAG9Z7o0edghn4+BiW2ACV0YZwHLhmyN/I+YW5YdgDNmBiJx8fM1PlG+L2P94f9ZB+L2ff+ifE4iIqKvnORVDO4cvfj2CR2FQ7dD8Q6TcJQ2eamQ1IpGldFyJIZXo5ZBNMdiGxsRhdLKA/oe0rARvgAp8FlKJOQB03I+h+PnkGsmZiMiliyzi0um02+G1PrddSANn5DKKmxWm4TSiTI5ZW+Rnx8OiV4mFeG/thy8CfXRfn9bgJjhuOhYr4dqXPyaKEEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA0PR15MB3904.namprd15.prod.outlook.com (2603:10b6:806:85::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 21:20:48 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 21:20:48 +0000
From: Song Liu <songliubraving@meta.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
CC: Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "nathan@kernel.org"
	<nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        "justinstitt@google.com" <justinstitt@google.com>,
        "mcgrof@kernel.org"
	<mcgrof@kernel.org>,
        "thunder.leizhen@huawei.com"
	<thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel
 Team <kernel-team@meta.com>,
        "mmaurer@google.com" <mmaurer@google.com>,
        "samitolvanen@google.com" <samitolvanen@google.com>,
        "rostedt@goodmis.org"
	<rostedt@goodmis.org>
Subject: Re: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Topic: [PATCH v3 0/2] Fix kallsyms with CONFIG_LTO_CLANG
Thread-Index: AQHa6RXv/gSdKg0smE2fR+VNyjAMObIkoH+AgAEanIA=
Date: Tue, 13 Aug 2024 21:20:48 +0000
Message-ID: <0C1544B6-60CF-44DC-A10C-73F1504F81D1@fb.com>
References: <20240807220513.3100483-1-song@kernel.org>
 <20240813132907.e6f392ec38bcc08e6796a014@kernel.org>
In-Reply-To: <20240813132907.e6f392ec38bcc08e6796a014@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA0PR15MB3904:EE_
x-ms-office365-filtering-correlation-id: b51d7ffe-0136-4e6e-42c6-08dcbbddcd39
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZW1NWVlEVFpTcWluTE9NYmZxVlJ5TTduWkpGdWZtMzZHVm5vODFyMkRtYkhY?=
 =?utf-8?B?UG8xNkJ5T2R0Tlp0MmlqWUpTQ3dqUmk4THJ1WE1EaEs1ckFtSHkvYklXRGkv?=
 =?utf-8?B?WWJ1L2NFSVBUL1Q0UTd1cHRNV0VWQ2xKNUczN0xwbkxVdjJzOW5DcHJTb0xh?=
 =?utf-8?B?dmpJZks4R1FOUnNZOVNFNHhmMGxWbTNnT3NUcTROUVE5RjQyYjduN3BYTUJT?=
 =?utf-8?B?NDE5NG9UbWJaRDRxaEJmMzZkcVRyd0JWRnVjdS83a0FHU1hlRjhONXJkQU1T?=
 =?utf-8?B?MnR2VjZEYmxyTmZiQnBjdXJyM1ZWdHlZbVVlTTVQbjdmWkF5bFNkNldWN3RX?=
 =?utf-8?B?N3lnTEQrbXRNckZBQnlia01JaVRqOEM2ZUJpZHR2aVRIQWxnNVBxS2xvZXhn?=
 =?utf-8?B?RnpnLzJNSzZ3MS8vNmhpd2JyN0ZQa3Z3MmY0dlVBaFdQOVhmVHMzcks2dThD?=
 =?utf-8?B?ekZJVkZqWVIvK2VLWHo4dXVXcUhTYjZvTFZxYVBza09ha0gvSDRuNzV6Ky9u?=
 =?utf-8?B?a1pYaWRObVZhQk0wcUNxcEN4T09KNEprY0l1SXNXTHlXOE5rYTFKUGt1eDJr?=
 =?utf-8?B?cS9mVnVNL3JzM0NYNkZTWS9sajVFOXc2Q0pXRHcxNEw4akNZVjZxYzRsQjVm?=
 =?utf-8?B?VDdDSXIrdWpKQWVzczA1Tjk2RG9yQ0MySnN4eFZKZ0ZyYkYrYkh2VmxWYmtk?=
 =?utf-8?B?N0k5WnlRdmREdUJFb2RqU25pZ3NvYytCaWFsRlQ2bFhac1hJVGwwemkyMGU4?=
 =?utf-8?B?cXRGK0w3bTNhSjhnaDZWMzlqMG5VZGpHVUl1TGFsbEVKMWhNWTQxNHlNdExu?=
 =?utf-8?B?SzFNc08yaUZDc0pHTjhWMkxTamtaMXJGUzcrQ1VkNkQ3MnlKcXNsSHk1dTdS?=
 =?utf-8?B?eUxrMitFL1lVUGVtQm5SUzF6M1RTb3I1azZFM0piMVZLaVYvQ3lpa2s0KytF?=
 =?utf-8?B?V1FtaURXY1VzLzhUUVFEdjluaGREWm9WUWdMUzVPanFZbVVFM0JvcHFidm1s?=
 =?utf-8?B?ZGM0MFdNcWdsblp6b1MrMnVEV0dPRG9Mbm1LSjFSL3NuZlM1bjZqVlUvdFIy?=
 =?utf-8?B?ZU1uSm44dW5nOUp4amRXOUlocEUzSzFCWENaSklRK3VKTFpIcWh3TjVxaWFy?=
 =?utf-8?B?eHc4V0wvbzcrd24rV1BJMDNkS2dCdENEb01ZN2JjYVBMWllyVFJVSzgzYUNp?=
 =?utf-8?B?ZXZCajlad1dqendqdUpvcFo1azZiU1ZtZWdETkY0UEM4ckFNL3hvdlRRYm1V?=
 =?utf-8?B?R3BheFF0bFBBS01OcmFqMHNmamhvY1YzeTZ6VkMyUC9kaG1acGtPbHE0TzZi?=
 =?utf-8?B?VjhHU2FvWHo2cGxnUmo4dGVMNHNFa2sydUJVU2o0ay9VM0lKdHVCNW53NVE1?=
 =?utf-8?B?MjcrU0tIbVRKUlJsQ0tieTAySVpQSGNHL215NGRWY1hYV0pBc2ozMWRHcSt1?=
 =?utf-8?B?NVVDVmhmb04wNlozeHNyT0NkNENZcWNjemUvWml2NlYyWUJ0Qy9kOXE3QkQv?=
 =?utf-8?B?aCs3aVZONlJrZUMycFAyTTZQMTg1V2QyY1dZMW02Q1c2Wkl6eEZOQ011ZzJ6?=
 =?utf-8?B?d1F5ZmN5cUUxejBzZThCL2NPTVQwL0wzQ0ZnOWFJcG92SVF6dys5VGhrTlFi?=
 =?utf-8?B?OEgvUHFoMUZKYWUyTDlQUzZXZzdiMWY1R2R6VHhPTFJEcUszRXBLMVV0ejl5?=
 =?utf-8?B?YVhaUUxqcVpheTlrVzkwYnBBcHlvUnpMVXM4Y3VxRG5BdXloQnFuSkJveXMv?=
 =?utf-8?Q?TFcrQL8mkkMJYDGymoUeGKSFKPUnf3ynBIMfw28?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWNqT2hFNkFlWHp4cEZ0TTFWNGRVdFgxWGx1Zm5tb3RncUhGb2E2TWt5WW5h?=
 =?utf-8?B?VGJOOWZjR1JYa0JnK2lsVk94eDZ3NHNocjNFbm9iM2k4U1hJcENNUzRIQjR5?=
 =?utf-8?B?anU0RUh0L3I1bjVENTlYejJLWWltVE0vdEJXMkpvSE1UUVB6SDlkNEp0TnFa?=
 =?utf-8?B?cHQ5QjFETmRONW9HdWowaVJXT0cxTVVHRTJDbjZ0WER5bjRpd1d1OVBtZmc2?=
 =?utf-8?B?ek9jVHdHME9LWUNLbGhkUW5tR0NFSkNqOStZd1FoYUoxTmVvWGczanBsT1kv?=
 =?utf-8?B?Wk85ZzdIVXo5a2RZakFJUXEwN0dpTUtyWk5yNmlmdjNJYXZ4L1Y0QXJ1bTlN?=
 =?utf-8?B?NDg0UXBrLy8wK1JINENNVTkyMGdkd2c4SjdzZzBUSW9UYzBtN0tka28vcERQ?=
 =?utf-8?B?RXI0WU1Sa2xQdXozREpuY211cURLNUQvTVBqbnFhc084YUhELzJSRDlpYWdw?=
 =?utf-8?B?SXlkc2dtNmk2ZzQrQ2VuRmZqNVk2OWpUR1Irc2Y5dWs4cCs2L0g4dkVtRU51?=
 =?utf-8?B?dUQxYi81RzlJVVBES0NpZGVqazVyRFpuQlM1WVB3dU5CZG1TWUFidXdYRG9o?=
 =?utf-8?B?eG45cjZFSEZ3RVpoUnlHZEZvc0w5TXhpKytMdzhIamFIUDY3T2t3RmdlSHo2?=
 =?utf-8?B?ejd1WjZtWG0zTnMvUmg4MHZ1dDh1c1RIWjV4OGhIdFkyaTh3WHVJa3BVTS9a?=
 =?utf-8?B?RW4xeWp6anRTYVRWUnFxSmE0blZqSGhaaGl6MUoycUhtVHhWQXRaaS9nNTZL?=
 =?utf-8?B?R0JDajh3OEdQTjlMOHMzUTZTOFVQOGRpTW9sRCtCRzU1YXdBMFlhU0VHdkxr?=
 =?utf-8?B?cW1JYXMxSXJlMi9XSlkvd2hNR1NuWWc2Mm1BZkV1UGs0dkJKYmJzWE5BWllq?=
 =?utf-8?B?bWU4eHVQSHV1Z1FlalZvVkgrZzBRT29kRThSZ2xMVktPb1JQSVpLQnN4ZmVR?=
 =?utf-8?B?emdsNGdYNmVqMWp3R0srMWhDMHhyZzdMeStGUi8vSzVaL0E1TDl5dUsrbFRO?=
 =?utf-8?B?UnB0YnVPbWQ3NWVYdTVVSDF6Zm00Y2tYcmkraVN2SE8wam1JTlpWeWVxZ2VD?=
 =?utf-8?B?YXQvZUtLK05QMWRhN2o2WExIak9xWklWTVlJV0k4WVRhSHEvT0xUeVRnRkQz?=
 =?utf-8?B?NUhKMmhwTnVDK1BsMTFaL21rVFZyeHBtUlRwV1FvWG5mWVEzSnhWWlJrQ295?=
 =?utf-8?B?OCtoTW14T0lEb2hPS1B1THA4aHhkTXZlZVVNTjB1Vjk0b252bm5BUDlBY1JO?=
 =?utf-8?B?NVBpblFBVGh6NjhzRUo3c1lWeVVYSDk0QnRoVHd3dkhyOVZZUjUreUxUZzA2?=
 =?utf-8?B?a29VRlJ3Rlh6UUdGbVdWK3cxaUpaNVYzQUZITWlHVXNxZWYyRTNFRW9NODNH?=
 =?utf-8?B?NGJGSVdDZ1crMTlEZVV5U3g0SW9YOXd1Z1djQUU4RFpUc2I5cUFhemNJcjdP?=
 =?utf-8?B?MTFPNzNTU0xFcHRJdlUveVVBTkFBWFY0czB6TlZTY0hzRnVQdFh5V0M5WnZz?=
 =?utf-8?B?UTI4cEYwV2YyUVdoeC9CNW1jMTZiRTZ0bk1KSmlReEl6clB4ZHRaMFJpelVk?=
 =?utf-8?B?bW5UenBQUC8rTGo4dE5lSXNzRkpGQUpWcjE5NEpmUm1aYkRLOGU3SjBwaGdu?=
 =?utf-8?B?YjFESTBHUzdLUGVPL1h2M3ZyWExYMWJCeFR0REhkK0x2QWpXWTY5S29WT09Q?=
 =?utf-8?B?SWhVdk9Samt6VDJSUVpxUkNRa2J2NUx5MVU5Nk5uR3pLVGFGaUozVHY1L3k2?=
 =?utf-8?B?TUxnd2V6N2ozOE1nazF4c0l5bGdNN2dNQmVsWDBQK3dzMWpLRTU1ZFk4cDk3?=
 =?utf-8?B?TjJkdGpjd0lWL2tPcGxQdHhwRTMvRWthKyt4R1poaXdOcEhxS1lrM1I4cjA3?=
 =?utf-8?B?UEdwbG1PNE4rNnJsSjJpaVRtOUM4dWlyY3BWNm8vYnVMRmhjTWJaZWlaZnl6?=
 =?utf-8?B?TUhua3AzcXBQSGpBWDZpOHVCS3VUSzdSK1VqZXk0ajV3MlVsaTZqWFRLTzJI?=
 =?utf-8?B?QnVLaXlNRXQ3SXZlbXNTNDlLcmx6TDdwLzd2a2VoWDQvMkllY2ptaU9VUXlz?=
 =?utf-8?B?em53eXBCV0t4TjRYZTg3Q0ozYzhhRis2dlRIamRTSDdYaGZuQzAxb3NpTm9Q?=
 =?utf-8?B?Szl3aGo4ZXFBQitNU0t3c1VhWkxjOTZORGhtd3FFUyt0Q0Q4UmhCRFRqQlh0?=
 =?utf-8?Q?kKKXhdvBZY5tm4r7TwoJIVk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE836487A63E6E4EA8451B87A3328858@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b51d7ffe-0136-4e6e-42c6-08dcbbddcd39
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 21:20:48.4683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18NX7jB2YXbd+qxbP1seac7QjNP3YfctGi3cnx46nbYx6kHJ1JWNJbnV7xwSuBZWLmkzjL5ebwtO5f6lTsT9sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3904
X-Proofpoint-ORIG-GUID: LTMqnZVlkCcLqaoDu-MSCYOCD48IFWPH
X-Proofpoint-GUID: LTMqnZVlkCcLqaoDu-MSCYOCD48IFWPH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-13_12,2024-08-13_02,2024-05-17_01

SGkgTWFzYW1pLCANCg0KVGhhbmtzIGZvciB5b3VyIHJldmlldyBhbmQgdGVzdCENCg0KQFNhbWks
IGNvdWxkIHlvdSBwbGVhc2UgYWxzbyByZXZpZXcgdGhlIHNldD8NCg0KQEx1aXMsIEkgcmVwbGll
ZCB0byAxLzIgYW5kIDIvMiB3aXRoIEZpeGVzIHRhZ3MgdGhhdCBJIHRoaW5rIG1ha2UgbW9zdCAN
CnNlbnNlLiBQbGVhc2UgbGV0IG1lIGtub3cgaWYgd2UgbmVlZCBjaGFuZ2VzIHRvIHRoZSBzZXQg
b3IgbW9yZSByZXZpZXdzDQphbmQgdGVzdHMuIA0KDQpUaGFua3MsDQpTb25nDQoNCj4gT24gQXVn
IDEyLCAyMDI0LCBhdCA5OjI54oCvUE0sIE1hc2FtaSBIaXJhbWF0c3UgPG1oaXJhbWF0QGtlcm5l
bC5vcmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCAgNyBBdWcgMjAyNCAxNTowNToxMSAtMDcwMA0K
PiBTb25nIExpdSA8c29uZ0BrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+PiBXaXRoIENPTkZJR19M
VE9fQ0xBTkcsIHRoZSBjb21waWxlci9saW5rZXIgYWRkcyAubGx2bS48aGFzaD4gc3VmZml4IHRv
DQo+PiBsb2NhbCBzeW1ib2xzIHRvIGF2b2lkIGR1cGxpY2F0aW9ucy4gRXhpc3Rpbmcgc2NyaXB0
cy9rYWxsc3ltcyBzb3J0cw0KPj4gc3ltYm9scyB3aXRob3V0IC5sbHZtLjxoYXNoPiBzdWZmaXgu
IEhvd2V2ZXIsIHRoaXMgY2F1c2VzIHF1aXRlIHNvbWUNCj4+IGlzc3VlcyBsYXRlciBvbi4gU29t
ZSB1c2VycyBvZiBrYWxsc3ltcywgc3VjaCBhcyBsaXZlcGF0Y2gsIGhhdmUgdG8gbWF0Y2gNCj4+
IHN5bWJvbHMgZXhhY3RseS4NCj4+IA0KPj4gQWRkcmVzcyB0aGlzIGJ5IHNvcnRpbmcgZnVsbCBz
eW1ib2xzIGF0IGJ1aWxkIHRpbWUsIGFuZCBsZXQga2FsbHN5bXMNCj4+IGxvb2t1cCBBUElzIHRv
IG1hdGNoIHRoZSBzeW1ib2xzIGV4YWN0bHkuDQo+PiANCj4gDQo+IEkndmUgdGVzdGVkIHRoaXMg
c2VyaWVzIGFuZCBjb25maXJtZWQgaXQgbWFrZXMga3Byb2JlcyB3b3JrIHdpdGggbGx2bSBzdWZm
aXhlZA0KPiBzeW1ib2xzLg0KPiANCj4gL3N5cy9rZXJuZWwvdHJhY2luZyAjIGVjaG8gInAgY19z
dGFydC5sbHZtLjgwMTE1Mzg2MjgyMTY3MTMzNTciID4+IGtwcm9iZV9ldmVudHMNCj4gL3N5cy9r
ZXJuZWwvdHJhY2luZyAjIGNhdCBrcHJvYmVfZXZlbnRzIA0KPiBwOmtwcm9iZXMvcF9jX3N0YXJ0
X2xsdm1fODAxMTUzODYyODIxNjcxMzM1N18wIGNfc3RhcnQubGx2bS44MDExNTM4NjI4MjE2NzEz
MzU3DQo+IC9zeXMva2VybmVsL3RyYWNpbmcgIyBlY2hvICJwIGNfc3RhcnQiID4+IGtwcm9iZV9l
dmVudHMgDQo+IC9zeXMva2VybmVsL3RyYWNpbmcgIyBjYXQga3Byb2JlX2V2ZW50cyANCj4gcDpr
cHJvYmVzL3BfY19zdGFydF9sbHZtXzgwMTE1Mzg2MjgyMTY3MTMzNTdfMCBjX3N0YXJ0Lmxsdm0u
ODAxMTUzODYyODIxNjcxMzM1Nw0KPiBwOmtwcm9iZXMvcF9jX3N0YXJ0XzAgY19zdGFydA0KPiAN
Cj4gQW5kIGZ0cmFjZSB0b28uDQo+IA0KPiAvc3lzL2tlcm5lbC90cmFjaW5nICMgZ3JlcCBeY19z
dGFydCBhdmFpbGFibGVfZmlsdGVyX2Z1bmN0aW9ucw0KPiBjX3N0YXJ0Lmxsdm0uODAxMTUzODYy
ODIxNjcxMzM1Nw0KPiBjX3N0YXJ0DQo+IGNfc3RhcnQubGx2bS4xNzEzMjY3NDA5NTQzMTI3NTg1
Mg0KPiANCj4gVGVzdGVkLWJ5OiBNYXNhbWkgSGlyYW1hdHN1IChHb29nbGUpIDxtaGlyYW1hdEBr
ZXJuZWwub3JnPg0KPiBSZXZpZXdlZC1ieTogTWFzYW1pIEhpcmFtYXRzdSAoR29vZ2xlKSA8bWhp
cmFtYXRAa2VybmVsLm9yZz4NCj4gDQo+IGZvciB0aGlzIHNlcmllcy4NCj4gDQo+PiBDaGFuZ2Vz
IHYyID0+IHYzOg0KPj4gMS4gUmVtb3ZlIHRoZSBfd2l0aG91dF9zdWZmaXggQVBJcywgYXMga3By
b2JlIHdpbGwgbm90IHVzZSB0aGVtLg0KPj4gICAoTWFzYW1pIEhpcmFtYXRzdSkNCj4+IA0KPj4g
djI6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpdmUtcGF0Y2hpbmcvMjAyNDA4MDIyMTA4MzYu
MjIxMDE0MC0xLXNvbmdAa2VybmVsLm9yZy9ULyN1DQo+PiANCj4+IENoYW5nZXMgdjEgPT4gdjI6
DQo+PiAxLiBVcGRhdGUgdGhlIEFQSXMgdG8gcmVtb3ZlIGFsbCAuWFhYIHN1ZmZpeGVzICh2MSBv
bmx5IHJlbW92ZXMgLmxsdm0uKikuDQo+PiAyLiBSZW5hbWUgdGhlIEFQSXMgYXMgKl93aXRob3V0
X3N1ZmZpeC4gKE1hc2FtaSBIaXJhbWF0c3UpDQo+PiAzLiBGaXggYW5vdGhlciB1c2VyIGZyb20g
a3Byb2JlLiAoTWFzYW1pIEhpcmFtYXRzdSkNCj4+IDQuIEFkZCB0ZXN0cyBmb3IgdGhlIG5ldyBB
UElzIGluIGthbGxzeW1zX3NlbGZ0ZXN0cy4NCj4+IA0KPj4gdjE6IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpdmUtcGF0Y2hpbmcvMjAyNDA3MzAwMDU0MzMuMzU1OTczMS0xLXNvbmdAa2VybmVs
Lm9yZy9ULyN1DQo+PiANCj4+IFNvbmcgTGl1ICgyKToNCj4+ICBrYWxsc3ltczogRG8gbm90IGNs
ZWFudXAgLmxsdm0uPGhhc2g+IHN1ZmZpeCBiZWZvcmUgc29ydGluZyBzeW1ib2xzDQo+PiAga2Fs
bHN5bXM6IE1hdGNoIHN5bWJvbHMgZXhhY3RseSB3aXRoIENPTkZJR19MVE9fQ0xBTkcNCj4+IA0K
Pj4ga2VybmVsL2thbGxzeW1zLmMgICAgICAgICAgfCA1NSArKysrKy0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPj4ga2VybmVsL2thbGxzeW1zX3NlbGZ0ZXN0LmMgfCAyMiArLS0t
LS0tLS0tLS0tLS0NCj4+IHNjcmlwdHMva2FsbHN5bXMuYyAgICAgICAgIHwgMzEgKystLS0tLS0t
LS0tLS0tLS0tLS0tDQo+PiBzY3JpcHRzL2xpbmstdm1saW51eC5zaCAgICB8ICA0IC0tLQ0KPj4g
NCBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEwMyBkZWxldGlvbnMoLSkNCj4+IA0K
Pj4gLS0NCj4+IDIuNDMuNQ0KPiANCj4gDQo+IC0tIA0KPiBNYXNhbWkgSGlyYW1hdHN1IChHb29n
bGUpIDxtaGlyYW1hdEBrZXJuZWwub3JnPg0KDQo=

