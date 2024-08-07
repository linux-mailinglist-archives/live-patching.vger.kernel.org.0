Return-Path: <live-patching+bounces-453-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5274C94B095
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 21:46:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0E7EB20D51
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 19:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3416E1448E7;
	Wed,  7 Aug 2024 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ksUQYpe0"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E9558203;
	Wed,  7 Aug 2024 19:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723059997; cv=fail; b=qLr4MGSS/X3ZgqTTYONhgTowQGqg5Yi5ZFtqPHP4MbOWdZaDbe1WVs+VBstCvgMquVsqlXno0ZA8mlG0oSIksf6HGRxKx657g6iSOCfXMqFuLZn7wgQDCPz4EfCdUUsD0URuYPc6rXpHvyWl4bjood1FGf8uLKg36pxQ7tZsHWo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723059997; c=relaxed/simple;
	bh=uOaIfONTT8ygmemy91k489v3HgMZze2q1XvgxzAbQTw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TuQrwGaHG/zMO6Abxhfi4UQ8pEqOYaEaEN6T8+CyustMNnhEVodJysTtZD7/R8IHXMvMw/ceP3834BBQYnwXs5Lw8QjcbML+gWmFbMvIgISi6rFsv6Pp3DZdMFbeySbuy8DbEM+0gFWM87FoUl4uIqgRhOAT4myjtrUcW04JOgY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ksUQYpe0; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477JK1Kr030550;
	Wed, 7 Aug 2024 12:46:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=uOaIfONTT8ygmemy91k489v3HgMZze2q1XvgxzAbQTw
	=; b=ksUQYpe0fFzKUDOIW0G/+A6H8XfqYGRPm9CfGWYvZyPmlW9x8QUJFXdshXs
	KasG/ZcySq6BRcDP3Eu93xNk6gH9SKzxz+HU8Foe7FggxDhHYPvB9KavMXJGX7hQ
	k6H/IXndRS8lRAw/g34wFXEy2de0mlkeKAVlJcljdXD9fg2P/pngJcVCF/WlggDg
	BbogKZD0M0diqcVCfUDCkxaJIPsFLEbKV138xiPrhqJsisHQpH7DsGOHhwn1tBxe
	agEwaLVLKtvSAv4NkXdbqJx6E3tp+6MfTdcSEvt2FuGUPZi1+tovvR8SYNA01aDp
	83dIqSBJL4S5dtXU20f27HS6uzA==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40usnkr5u0-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 12:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GIK5q4i/wruGxH/vOi/mY9CGgvlCf0D3bW/PWZpWJ5On2dZ9qGulzgBUvVBJb+ntygHSr5Z0fbKopILTonv4QSwCheledw+5ogPOTqaAC7HitrJu2jyKelNSwcPxVdjtfm6jGk/n59Z44iysgE4ThpQ4HhEg/JwxSC74oL7EtKlESiUj1N4DROj7pdr9tWBXbmSKBZMwokNEGCRI1bqLnOu6zOhsy9eqdI/Czr0PsgiYBEDmWf35dxeaJBEhPrk7RfNzY5YRmVAw+jd/J/1xRkSwL07lmKr6GWFErOO22lUyZkGlibGrhAn3w1S7/GLLnOmR6KfuDpgu/ov49GOxhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uOaIfONTT8ygmemy91k489v3HgMZze2q1XvgxzAbQTw=;
 b=T6kHcB3pSXCJG6NW5KFahiBzVPrxpEg2kGUkAL48KOZfZnSMujoWcfIBhwTNNiWLnLWXBluorictGtfhza4Yfx2CHCTYAoLXYGNCUEQlIXRFc1fzSb1P0s490H5Zo91TWpwEEERWOyCr5Vr/WWU9wkbrpUR2YYVXVdJTb1ICTodnpGmWsYuomY0RFmwIpdzW9k7DKLHR5y3EHk5teymucUe0Kk2WkZTIz9WQo/XdJMJ233Gc+Yp5k/XRq3frx2Eu1IIsW55bbyQezv03Taas6jO8O2Sfgu9CAVytywFd4sBjZUA7g+twKETCPmHu2tgxSOEUJvF0+EZAeT02aosZLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY3PR15MB5026.namprd15.prod.outlook.com (2603:10b6:a03:3c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Wed, 7 Aug
 2024 19:46:31 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 19:46:31 +0000
From: Song Liu <songliubraving@meta.com>
To: zhang warden <zhangwarden@gmail.com>
CC: Song Liu <songliubraving@meta.com>, Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <song@kernel.org>,
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
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAATqbgIAAUFkA
Date: Wed, 7 Aug 2024 19:46:31 +0000
Message-ID: <22D3CE6E-945B-43C4-A3A2-C57588B12BD0@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
In-Reply-To: <87F7024C-9049-4573-829B-79261FC87984@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BY3PR15MB5026:EE_
x-ms-office365-filtering-correlation-id: 79bc2355-c997-4909-6c3a-08dcb719a2be
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?bE5TazZtQ2J1b3hVbUR4SHA3UmZLY3pIY0ViS2ZMa0kzQ3VoV0NBc0FrdWlN?=
 =?utf-8?B?cUhyajVzVVF3QWN4blY4L1p0cXNMUncyRFBIVnJZYlNlK0x5ZEdyMTlkZ1hh?=
 =?utf-8?B?UFFpTzZPcDFrTnpUTlVoeXVZb3J5SXJWa2xSbGdWRGJZZ0dPU0VtQzdOcmRF?=
 =?utf-8?B?V3NZYmQyTFJQNUttL21UcEMvRTJzTjhKekwzeU5ITHE1K21ZVmJVV1RTY2lz?=
 =?utf-8?B?am1ZUjhUNmxQMFpuV01VWWU4dUF5MGJCR3dMZU11eEp6OEpOWVF1WTlNOCts?=
 =?utf-8?B?YVdndDRBZWF2MUs0ak1qVWs4ZUQzQklhS2ZYQU5CVmpvZXFXZExaS3dPSlhN?=
 =?utf-8?B?b2kyUUxuT1IxNWV6NFJUWTZyazM0U014UXZhMVl5SDlJa3NreTRnaElOa3lO?=
 =?utf-8?B?MDQ4S0srY01WUDhiVk5LdUgyWllqSDlHZ1o0V1ZEU3pDOC9VdEJYTitlV3hk?=
 =?utf-8?B?S29sUTlRWEFZMnNvdkdzTUNpb056cm03U0poWUNXUmV4Ni91TmQ1MHRKTVdm?=
 =?utf-8?B?Q0I3NHppNERjVEZNV2o5OUdkK2lMcDZCVGp6QjlaQmlZeTBMckVOOVpyZ0VS?=
 =?utf-8?B?RDhvQ2EyS1VHU1djOHEzNFJPRmEyOXMva1lYQ1ZPMmUzbGFDZGkvRDZwRmdV?=
 =?utf-8?B?b2ZWZGtmS2FKK1Vwb2EzNHpSbjJwdGx2eUM2VHlIY3VUcW81eWJOTXFMcGx0?=
 =?utf-8?B?QW9vZHNybkM5b2kyK3dzMzJ3bHlHWmkyY3ErbmJndmd3eVh2NkhYNEV5VUVy?=
 =?utf-8?B?RWVyYVNpa1FFb2VCUGtkbWRyVnZJT3dvTFV0bkE2ZXc4NTRzd2ptMlZMVlhQ?=
 =?utf-8?B?MEkvN0g1TDZNL2tkSVZZSUQ5ZDhyLzZEQWRUK2NvcXJwVHFvMkZObWVWdUZi?=
 =?utf-8?B?ZTJXeG5ENWVlbGZvU2UvMVZlczg5Y25KREpKTTA2ODlrdWdHWWRyK25SZ3R1?=
 =?utf-8?B?YmtObk5BclRxblJNRUh0TnB4VnFsZ3poR3NBNE5EL1kzWjd5L1lVTktNbmhs?=
 =?utf-8?B?bHhQUGt6dUpIUDdMK2V4cmhmWG5BSmV1eWhXandGMkQ2S0dCYWtxTXl4NW1L?=
 =?utf-8?B?TnFmNEFjK3NIbnVqbTNWU2JyWUJwWXVQVjFRdVRicDNiYzNXMmh4YW5OZjE4?=
 =?utf-8?B?Kys4RVNETkFyRW5LVnBPMUV2djcyNVFwTU8vdkI4YUU4bldhMDFZVnJrZmdi?=
 =?utf-8?B?a0Y4SUpHYTk4WVF6NTA4TUxrSEhnRU03WElNM1V0MVF5K3BvVHZpMm5CY3Zn?=
 =?utf-8?B?SmxqMlVhOHRFYXJCTkFreEJGZEtoa05ERURFWEsyVVRwT0h2QStQZnBIei9p?=
 =?utf-8?B?UXN2MVUvTk8wTFRnRzlYYnNXdERNclZrTlRKTjdGTi9WQUVQam5weU1zQnU3?=
 =?utf-8?B?NmFhVWFBRHBwMkZRQ25ldDBmN0tXamRwbk5kS052bWozbCt2SW1zVGhoT2xY?=
 =?utf-8?B?V3BNYmIzcVo2anFmNHlSUk91d0lsbGUyQVFyYTNvL3JDWXRscnZNdUJVYk1Z?=
 =?utf-8?B?Q1NzS3pjOFdPdkNWNGlkV2FqZ1R3RVRFcTduTE9raFJaV0RpSUlHNTF0UWFo?=
 =?utf-8?B?SUhZTmFweTIwZHUxUXJrODRJNnNQMVFRa2hxbnFOdmVhbGhaVnVTMWV0YVpI?=
 =?utf-8?B?djJOaStZRnVsNENHUUMzWFBBUmxlMkMvK2VlNHB5QmZRZ2s5YjQ4UFhNejlD?=
 =?utf-8?B?cjhMQVdxeVdITHZ3UitCNW5FZGdOejJwdDdiVUw3MnA4UEsveVFtZ2E4SFlB?=
 =?utf-8?B?d2xHL0VraHE5b2FtQUxHajBLQkxNMkpoeE1yMDVVWURQbEJ4NzFtOGdndFFO?=
 =?utf-8?B?cmJNVW5IYklhcFViUURKbVJJMFh4MjgxMDRaQnZJUjR2aDZ6aU43VjBtQ3ZQ?=
 =?utf-8?B?UUZvRTdycDlNYmJ0T2xMT0RFdDRzUTl1citwSnVwc0cvZ3c9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WWozYmZBSnJhTVY5V0Y3UjRkS0N5b3U4aTVwR1p6ZXEyUjRmejJzYU14ME1Z?=
 =?utf-8?B?ZElpdDJzaWN2TktQbWJTZFpmUHAvb2NFS0ZFdXJvaEM4Wm9pdUpXcHZ5SVdu?=
 =?utf-8?B?V3N2MlEvbDJTVjREaXNXRjhQZDRNMnE2ay92RHNuVGxQeldDTFpoODdjQW1M?=
 =?utf-8?B?ZHB5THpIVEF0dEN3cWJYKzZQSW5ucnNQWjE2QndrZ2NyaitjMFVxOURoWWQx?=
 =?utf-8?B?Z3ViQ2xlNVdWTkRINHZsb0tCWTZ0bGpFU0ZSZGQ4V0lpWWNKMDh3TGs5YVoy?=
 =?utf-8?B?bmpOaGNVQmhoOTU0aGhkZ0gya0JTTXJweXdOcE5nQXUwVUhWZlJ0R3JOT3Fp?=
 =?utf-8?B?YmFmbk1aMG9GQnlhUlhqck9rdzFpM2pvTW5LQzNEdGF1Qy9IYXN0VzRjcE15?=
 =?utf-8?B?TWVadnN6RXRzdjQvYk5ZNDFuNlVOZjQ4a25DcGlsd0R2MmFHRVNNd2plcmQ2?=
 =?utf-8?B?TjJKTFRxanN4QzBxU2k1aE1oSmZkTTN0THNEdEZ6OUlVUE9HZFFrSUd1Y2Fl?=
 =?utf-8?B?N3NqUWVKWFZQdmphQ1c3RzI2UHlzc04yeGduSEdQWDlsNnlOempVaDVNaGhl?=
 =?utf-8?B?MmlxVFJ3Z2I2VjZ0VW9VVGM1cVByTnFUelRjNU43cFJ3QXphYnVFS1lqM1JR?=
 =?utf-8?B?b240ZlI1M0pGcnRER0FIQmFXZ005TFpJVi83S0hGL3hlVFQxT01BeHFtdjRp?=
 =?utf-8?B?REQyT0ZqU1VuWVlPTC9rRXB4NDlQVzRwbDNJQnRXSTlhTUhzczBZeHJQNWZs?=
 =?utf-8?B?QTk0OFZ2a0d6SWZNUTVMN3BVRzhRSElsNzNtYUVOVzJadDVIVyt0UGRjbklI?=
 =?utf-8?B?cVRoa0tybXZxd3UxQVRqNS9rNVUyMkpNeUhNSk5PZGRvWTIwOU1zMGllQ25F?=
 =?utf-8?B?RDBqR3ArdjJHdXBzbjZ2TmdmTTRTd3ZnRlhlMWt0UFU5MDNubEtwem9qYU1v?=
 =?utf-8?B?NGVnaVFOcjdXOHYyWkFDU2RMd1VMUEdZUHowVWQ1dlJMVEpwQ0FKSWZPQmZn?=
 =?utf-8?B?QldXTEg1TGJEcElyeXRtby9YMUVOeCtTK3dLVlFZZGhEQllVZThuWHVwQ1M1?=
 =?utf-8?B?SzRQVnI5aTVwcTExTGdVZEg3ZnRDYmhua0RqMVdUakl3ZnpxQUlzVUlSWllw?=
 =?utf-8?B?R0s0TVpCWG9kdm9uTHF3NjVWd3ByMW90UFJ1RGIvZmpOKzIvb3k1ZXR0Z1lQ?=
 =?utf-8?B?MFBCQmJTUUlvOTk1dlN4dytKSnZ6VTVHM2JjVTNCYmpsekhqZXgxSmJCREhp?=
 =?utf-8?B?RWw3ZkFkNkQxbU5PTVJ4bitVSStNYmVFZStxQXlIbXoxYzZtc2ZZQWJ4WjdT?=
 =?utf-8?B?NFZiV3QvQnlzbmVjMzBHWkx3ellvVUtoRVEvQVpYMjZpRFJISFVJKzFqenlx?=
 =?utf-8?B?MU1vMHY5ZU5xNzhSeHFMM1FCMmY2MHplZTlpRko4SDF5a1Bza1daQXNQaVBq?=
 =?utf-8?B?M0xYczgwdmJoMmRBdGhCUytKc2pleksyeWZNR2pEY0x1azFyWXk4S0hVbHF1?=
 =?utf-8?B?QzVZMFFkRGZ6L0dYM1hQZHQ2YmpPM1YzZCsrWU42YVN0M0ttdU1vWjJWQVZT?=
 =?utf-8?B?ZEpYRWluTkhKNEUrWm0zcm5VRFZJVWJML0N0ZVI2bGZsUTBXeXdRRXR6L1Bp?=
 =?utf-8?B?aGcxbExEdUgvWlpNRUdGeHlBOEhTaURBOHRSU09HbnZTZEdZVEVVQVhDRC90?=
 =?utf-8?B?MStTOVZGMGRXZjhEaHpMdVhkemp3RGNnbUx3YmZ5RDUyRlpWY3Nxd2R2TVY5?=
 =?utf-8?B?cnowc2Y3aFdUZUF2WGZDWUZtZzNwR1AxK1dzemxLMXBueDVpSlcydWNYSGRp?=
 =?utf-8?B?NlJHOGhwcTUyUzhsYzNNdkpJaFBPLzB4SnVRTzBMbU9lcUplR045NGlYTjJx?=
 =?utf-8?B?bXhudVBDY1d5bnROOVgzN0JBYkZGZVpMQlpNNUl3QWZjZFB0Mk1aUVRia1hZ?=
 =?utf-8?B?b0lmWjlGdDJZRlRxOGd6SUptK2lxMmZRUmxOQk44SC8waUVwa1FIUDNYd05m?=
 =?utf-8?B?dVhJbWhML1A3NzlrUzZkam85OVppMW5KK0QxdUxMUVRYZFZuVUZIVTRlbVZG?=
 =?utf-8?B?dEVmTHorUWl1Qmt4TXI0TnNvQ2ZJU0lUOStnaXhadWtIYVYzck9oNWl5eitk?=
 =?utf-8?B?eStXNm1jUmU3OHpSNDF0c21wcWt5RkNlN0FTbUtyV0EzVFV0SGU2TGErbjZW?=
 =?utf-8?Q?0JCSpaG1+pHDtWfGvv527SM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2DF88B56714A848AEB400384DB7CDEB@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 79bc2355-c997-4909-6c3a-08dcb719a2be
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 19:46:31.1805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kWubYwixfat0lG0wGa/oz2zfPQ7jBFQAwFxi2Eotj6M86k9e86y8S26N4vErXNElkwcm8JpRD5gjugWagXutIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB5026
X-Proofpoint-GUID: 3gZ-oQy7-YNaYVrbkWnKG6_6B_v1voE0
X-Proofpoint-ORIG-GUID: 3gZ-oQy7-YNaYVrbkWnKG6_6B_v1voE0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDc6NTjigK9BTSwgemhhbmcgd2FyZGVuIDx6aGFuZ3dh
cmRlbkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4gDQo+PiBJbiBteSBHQ0MgYnVpbHQsIHdlIGhh
dmUgc3VmZml4ZXMgbGlrZSAiLmNvbnN0cHJvcC4wIiwgIi5wYXJ0LjAiLCAiLmlzcmEuMCIsIA0K
Pj4gYW5kICIuaXNyYS4wLmNvbGQiLg0KPiANCj4gQSBmcmVzaGVyJ3MgZXllLCBJIG1ldCBzb21l
dGltZSB3aGVuIHRyeSB0byBidWlsZCBhIGxpdmVwYXRjaCBtb2R1bGUgYW5kIGZvdW5kIHNvbWUg
bWlzdGFrZSBjYXVzZWQgYnkgIi5jb25zdHByb3AuMCIgIi5wYXJ0LjAiIHdoaWNoIGlzIGdlbmVy
YXRlZCBieSBHQ0MuDQo+IA0KPiBUaGVzZSBzZWN0aW9uIHdpdGggc3VjaCBzdWZmaXhlcyBpcyBz
cGVjaWFsIGFuZCBzb21ldGltZSB0aGUgc3ltYm9sIHN0X3ZhbHVlIGlzIHF1aXRlIGRpZmZlcmVu
dC4gV2hhdCBpcyB0aGVzZSBraW5kIG9mIHNlY3Rpb24gKG9yIHN5bWJvbCkgdXNlIGZvcj8NCg0K
DQpJSVVDLCBjb25zdHByb3AgbWVhbnMgY29uc3QgcHJvcGFnYXRpb24uIEZvciBleGFtcGxlLCBm
dW5jdGlvbiANCiJmb28oaW50IGEsIGludCBiKSIgdGhhdCBpcyBjYWxsZWQgYXMgImZvbyhhLCAx
MCkiIHdpbGwgYmUgY29tZSANCiJmb28oaW50IGEpIiB3aXRoIGEgaGFyZC1jb2RlZCBiID0gMTAg
aW5zaWRlLiANCg0KLnBhcnQuMCBpcyBwYXJ0IG9mIHRoZSBmdW5jdGlvbiwgYXMgdGhlIG90aGVy
IHBhcnQgaXMgaW5saW5lZCBpbiANCnRoZSBjYWxsZXIuIA0KDQpXaXRoIGJpbmFyeS1kaWZmIGJh
c2VkIHRvb2xjaGFpbiAoa3BhdGNoLWJ1aWxkKSwgSSB0aGluayB0aGVzZSB3aWxsIGJlIA0KaGFu
ZGxlZCBhdXRvbWF0aWNhbGx5LiBIb3dldmVyLCBpZiB3ZSB3cml0ZSB0aGUgbGl2ZXBhdGNoIG1h
bnVhbGx5LCB3ZSANCm5lZWQgdG8gdW5kZXJzdGFuZCB0aGVzZSBiZWhhdmlvciB3aXRoIC5jb25z
dHByb3AgYW5kIC5wYXJ0LiANCg0KVGhhbmtzLA0KU29uZw0KDQo=

