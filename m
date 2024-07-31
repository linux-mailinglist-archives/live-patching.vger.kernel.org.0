Return-Path: <live-patching+bounces-424-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA77194240E
	for <lists+live-patching@lfdr.de>; Wed, 31 Jul 2024 03:10:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B1161F22060
	for <lists+live-patching@lfdr.de>; Wed, 31 Jul 2024 01:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848DF8801;
	Wed, 31 Jul 2024 01:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="TqPc41y3"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CB5748F;
	Wed, 31 Jul 2024 01:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388204; cv=fail; b=BsNIAwdDWOtNaTizVKwXaCUjVAaSpbN2/aDrVdJl99VgBgPm2kBLHKnAO0x0cOnsOq38YA5YMm/xvuFjYFouif0A5gjigSejQOQuRSwoCZv3EtJYfVioa1AFzvEr7rJW1Pzi4FnPKxMD2bHRQxY1b4RXB6IOGb3mR7iErjq/2tg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388204; c=relaxed/simple;
	bh=6KzYBqpYK9CkigmOJ/0YNbiI5DH+ecOJK9ZtLz/V9SQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pGJpH2HDhoCpLzZMtVDvtb/puCi8uRu80KMm3fc82E7EvcF8yP/IF2pImlSEs4DBMQlkbbt5A1TkrogkDwgP9eI0C2g7sUPFxKjaCe6pF4gflCB9aNtF5muYL71wgLuWA1O8yNeOGtpWz32slNi4C4TTsu4mZu1+aehHzdQj33A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=TqPc41y3; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46UNqkw6003717;
	Tue, 30 Jul 2024 18:10:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=6KzYBqpYK9CkigmOJ/0YNbiI5DH+ecOJK9ZtLz/V9SQ
	=; b=TqPc41y35i33Z4j/FMI4zm9g29YG/tlsNDsh78r+ZDF8RNs7R7jrU9CRlaj
	P4u1LL1wTyYSEFsw791j9OJEykwN8CWFGsSOHu+2pqbHik4bmWBNP2G/Gn0jlPPZ
	GlK2XQa6JBX+SSd725ADYUCbWRpt5lLO2uvTAD3kgo3pc84VRSU1OmGTTLXUWiDt
	nZD5aJnERKtSNMaFFnjgzOvyb/ZwUDkikNpFR/uoEU4zUDBF6zvXoMjGP0/FZpa3
	jcazcD4sIZ1PNcmo786DHb81Q8/Z7ic5UPfIFMx/zRLRYOMcdjqvaUGWi38Pygsy
	oXtfBMLPHKr6pr6ZZIaUJBMNG3w==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40qa6g0c66-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jul 2024 18:10:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZ/uuaQm/cCrYAe+GkN3AHKu4v4QeTuyl1VEEQyeB07QiEiNLwFZXtENoNoAUKEcLZLlaQ9a2Grh6lpbS8GL94Ji9g7+/aaI/UWs7X3vFr5JWVDL852IbBFAdOsxd55Bwksq2yYC14H/2umW1+xEW2NX3Swfmnf2dPscWlRnSxJjWlnp6smLVOlKG2QzUXnOInxT71wWA4Squ23UwQKLsJDzbYakNPmt/a12ZjGbOilVsH/zuIL9TMf74YIB8wHea/e9Mdn9x4e51gXC8AgQ7Ny6ZY0wieQEeocowH2D6NUCDOKZ9Qnnb3dxwu7V5byCZc2CrwlAj3huB/KlbKOn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6KzYBqpYK9CkigmOJ/0YNbiI5DH+ecOJK9ZtLz/V9SQ=;
 b=yauBgwAl07ZlKeIv5x3iV2vz5/EefXH+8kXfSUmejwL0USRiCbkjOWZTnadhHZBBSyBpVzffy45gj6C/N8ktfsoxjggMNPO4JRdwoz1b99UBk3JplY0LDk2vyMqqacAcNXpGmyvUy25Knja6a/qcqY+ZiNF+g6CFzpUUTHGuJf5+99JJXeHBxNX1E8l/iHIZO6muebazHQV1zXY0QUmvLAFJ461+O8I4YcFu/9bkaQre61CXnQC2sXZ4Ciboo80vDgeyKTTzNseUuZGPh49yZIvYGQv2kU5LzvTjquas+MMoImdLcklmF1R7Sep/Ot7fbj8t7LsBbTBSUsLDVX93oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4230.namprd15.prod.outlook.com (2603:10b6:510:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 31 Jul
 2024 01:09:57 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.016; Wed, 31 Jul 2024
 01:09:56 +0000
From: Song Liu <songliubraving@meta.com>
To: Masami Hiramatsu <mhiramat@kernel.org>
CC: Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
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
Subject: Re: [PATCH 3/3] tracing/kprobes: Use APIs that matches symbols with
 .llvm.<hash> suffix
Thread-Topic: [PATCH 3/3] tracing/kprobes: Use APIs that matches symbols with
 .llvm.<hash> suffix
Thread-Index: AQHa4hsg5jHMjp8ZBkauqUpgUlR4erIPPcGAgADKswA=
Date: Wed, 31 Jul 2024 01:09:56 +0000
Message-ID: <CBD9DDC5-B679-44A3-B225-C60F14DC762C@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-4-song@kernel.org>
 <20240730220417.33bd5f0d75c3742c413136d1@kernel.org>
In-Reply-To: <20240730220417.33bd5f0d75c3742c413136d1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4230:EE_
x-ms-office365-filtering-correlation-id: aa1036b8-73f2-48d5-af55-08dcb0fd7e21
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?UHRHZThZUUE0NmpPTEhVRTY1azltQU1JUXdjZmwwWmVPZXZBS0w3MkxKek9h?=
 =?utf-8?B?Vkp4aHFmVVhxdFU3U1hWem40Z0FpVGNRYm10RU1RV0llT3BENWFmNDBoeWo5?=
 =?utf-8?B?NXR1YUhsOGp6eDdaRjB3dVdEb29TVXI4SGtPMVNSeUFPNHR6azBpVEpSWExi?=
 =?utf-8?B?dzM3SE1oTmJkUjdlYUEvNXhpcHV4WXdRSkNMWXRvSkRVUzhkYkErNCtZUkMw?=
 =?utf-8?B?aU1Qc3NtOGYzS2xsU2ppQ0lOQW1qU2pzNWFleExrKzYxVzIwcGZXazV1TkZ4?=
 =?utf-8?B?RzRvaU9VTnprQldiVzJLQjIzdVhUZFRTeDZ1SlBCUHNKYmRFNm9ZN0UxNXVD?=
 =?utf-8?B?eGxzS1FiVjlHOG4zZldkQ3F6a1NzZ01kQ2ZacXZTQzBKRUpqeEJCQ1NKeG9p?=
 =?utf-8?B?bHZEMHhWTGgrZGljdG9pY3ZCUW1pemQvaDMwbzVpZ3ArS2NMdjh2b0o1bXBi?=
 =?utf-8?B?VWhYL2MvdGdqM3IwTHpObFRhNUJRY2pMQXJsZ3JrTHVqNis4SHZRVmJVeUpx?=
 =?utf-8?B?akFxLys1R1hpVVd5NFBBa254aFNHUlhwME5MSFlaRlQ1akJSaFdZeTNIZ2Ir?=
 =?utf-8?B?QVBzYkVFNHp0U0pSQjdJUm1pNnlkS29ZdCtTMVFSaWNJZlNSN2d2aDcrcHZh?=
 =?utf-8?B?NWtrYXVnbUpMZTdzWFBkbnlVdHlDWlY0Q3ZRTEs4OEdaZy9LRjJaZWllUlgw?=
 =?utf-8?B?akhXVjArSDZjY3Z1L0l5RVFnWER3cWhNNjRvUE1EKy9CTGtVM1ptNFRXUU9m?=
 =?utf-8?B?emcyY0t5VEZKSDljY0NZZkpCSmpxc0FSTjNQQ0o4SnZnUkExZDREd2MrTjBs?=
 =?utf-8?B?d01YdmRxMGgwbVlTaEsxOUJLam12YlBQOXFxR0Y3d0g2R2ZSd005bnpTYU9I?=
 =?utf-8?B?Wit1ZlU5Wi8zUUQxdkVZQ3lYRUJFa3lvTVFNUm9FMndqemxURDhrbEtUUUxI?=
 =?utf-8?B?b3d2MUxaK216NFFnMXZ3YnQydGh3b3dRRHQ2dWxIcFhkem56Z3hYZVlyVUV1?=
 =?utf-8?B?azFHdGdKdTlvSXBTcGtqUTRuZUwvbDZxS3F1MnRReFJHYmdZWW03UWlRZlhX?=
 =?utf-8?B?M0x2UWt6dDh3MVh1YzFpUzEwKzFqZTdhT3hITWdPZ28zR0h0SEVnVDRyYm1T?=
 =?utf-8?B?TlZ4Q2R1TVBBQzJGYW1NcTlhUkpHKy9jdEk2WFBGYW4wbExmTThkOTFxYThI?=
 =?utf-8?B?d1BaenZETXJXb05zeUhwRlNpYXI3UzdYMUZsVURqekg0UEt3OTFDcFVoRXB3?=
 =?utf-8?B?QUxwQjNDVEd5VU03eTZsRFZzM0txTWdaMnF2ZVdVS1dkM1JnOHdYeWx0bHZ5?=
 =?utf-8?B?UldTUXdXWThLajBHV0svak9WZ2ZhREVyc21Eak16dG9pSmowRjAwVVcvRUt4?=
 =?utf-8?B?Qmt4czJyQ2FHbEt4L3Z3aW53cS9oa2ZtOGVJeUNub0JnaTNBRndVamZ3RXRH?=
 =?utf-8?B?TVNYeUM4MTBqOHZnWDBCUUhyWFZQdE83SGVzUktjL1RJWnpabUxjY211N283?=
 =?utf-8?B?QUFKMFNIVDJ5VkRueVJEVmlMRkFJK0FQbURlSjVZdi9kSjE5dlNOOVVtRVYr?=
 =?utf-8?B?TmpRUTNiN1BLc0FjUktOR21nN040V2RuTlhCNUt0cElCVGdTZTF1L0ZQdStu?=
 =?utf-8?B?bzlLaU0zeGc3T09QN0JUd2xrNDhyRW10ZGpGdndkanBGVkpmTTNCYzBNamVJ?=
 =?utf-8?B?b0J2c2gvLzBPR0lwMUl1VkZYK2lTcUpOU0RuK3lGOTdTM0QyWUNaMDJnK3Rv?=
 =?utf-8?B?cjRRRFlSZ3lVL2NvNTczNWFybnV3NElHY1ZzaXlZQmY2Yzg4enZHZmNWTWk1?=
 =?utf-8?B?aURhSXpLSjgvaW43UGlEMFd0WXoxUkJjOHN6b3J4eWRXYmV0S2ZHTi8wVkZC?=
 =?utf-8?B?OTU0WGtaTExWa2xWajFjUllpMUNRSEswS1FUQXFEcU5pYXc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TXduc3ROVUdVZkhyOFdpeXU5VncyLzBiZXp4d1N3eEREVUxIdjFwemRtN05L?=
 =?utf-8?B?bWxqOHIxWm1SVmlRK2Nvb2ZxS3pZdW14cG1hd2NwR2N0NTdZOEEvWS8zNTM0?=
 =?utf-8?B?RnpBaThOK3ROMzhGbXA0WlljMHNGdVdiMUI1aWFjRFhpUEF5NnRidU5nMmVN?=
 =?utf-8?B?clAyTy9sZ1FrcTFKVVJsa3J2TEJ5dVhkcXdXNjJuck9keTQ0TG5UeVRFY29J?=
 =?utf-8?B?SEwxcERqb3A0RE1mSFl1cmFNd1BWNkdZMVBiTEIwdG00TytlYnV3VGdDUnZ2?=
 =?utf-8?B?RmVJSDlxL0ZFWFlZRURQaWdFWDZ4UXNIS1VDWktUbWhmYmd4YW5EKzRBT0ho?=
 =?utf-8?B?K0cxakhoVWtZSTY3RUlYZzB3Ym5YenR2R3B1MGYvSURkZlBoc3cwQkJqdmg2?=
 =?utf-8?B?emlTd3djYzNZazc2S0w4clJCS1FOWEdYRXEvemozVFluZCs2Q1pUK1BFQVRI?=
 =?utf-8?B?eFZxWjU2UlZnNGx3UVc1d2dSTFFvTVc3MjY2ZEtHU2RmSnZweHhtQ3BueE93?=
 =?utf-8?B?azBhTndsNExEMUFXMmxNcjluNnJRU2xvd0xhZ0VkSjB6NTRDeGJXcGI3cndw?=
 =?utf-8?B?TmdPL0JDNERsdW1iZmhxRTUrb3ozK1dYWmdVbEpGZFpER2diOFZuNkVMZW1P?=
 =?utf-8?B?a3AwRzk4L2FUTXM1TFN3UUZ2eXl3SWhrMVRhTCtrUVpCV3lNZzNGZUErelFJ?=
 =?utf-8?B?SFJMYkxHNHFVb1VNeWN5Mk42REIrQWJlL3JCZ2ZPQXYxQU9tMmgvOWpjT09G?=
 =?utf-8?B?MGVscnZiODBDbXFhTlA0N2x3cGNCTDlkeGJDVG5sVVROeVFsdS9pMXBmT0Vo?=
 =?utf-8?B?MjRzK1VwZmlUTXRKT0NjVUFkNHk3UEtyTkxMcXcxc1NlcW5mT3duRTlQZ0JC?=
 =?utf-8?B?S1QxM3VwT1RNOVdWejFDUjI1UHA3b1FrN2x6cUxNbHlpZTNXRG1ETzVwUk5K?=
 =?utf-8?B?TkhWWnF4UkFudkNQQURwZWlyaHk2WTRIWVpMeWZaYmRSN1JpM0krTEJ5WUQx?=
 =?utf-8?B?djZHTzdkS3VZWVh4VEt1MWRIRlVLSWhrVFFFQ3k3T2VWcE5oYTJGZnJkRitx?=
 =?utf-8?B?TVF2Zm5MMXkzTVZTa1haU2s2ek90YVQwblI2NW9oOGt6Z28zdkVpY0QxSHk1?=
 =?utf-8?B?Q1BtS3UyUXA4Q1VyQ2xYWllXd3poOEFQQzFoZUtZL0dXWWR2V2RSOG5Lb0Fl?=
 =?utf-8?B?NmZrWDI3dXRERnRNM3ZKSnhVRGhsTlNhajlBdmF1SkkwWHZLd2ZUMkFBbFJI?=
 =?utf-8?B?NTVCREVFSzVhNkpwQWx6TkpuODQxTkpnUjc4bGFyWXZCektSZWhVOXdLWkR6?=
 =?utf-8?B?UDA0RCt5TlByRHF1YUVtanQyWVZ6TGF1RWtQQkNkbE1rNWRLanVGZThONE11?=
 =?utf-8?B?TkJvVjVhZnhLYlhRbDZvQk5jTnZuVE5IdlNFbTJ4dlR5VERpbVFqMnRmN1M5?=
 =?utf-8?B?bitwVGtiYytCNUxlckJFcDdmbUg4alRzSU91cGNuRmxsTlY2ZE9sanRjVGVY?=
 =?utf-8?B?WGIzNTZGNmE1YWlNTEY1VVJDdHN2bnIzeTJ6U3JFMFNFalprNkVVUlBVb3Bw?=
 =?utf-8?B?Z05IMTVuWnhma2JwMEJlcXBuY2xFRWF0cjVkT0ZDRHlScHpvblRzZ2dxNytR?=
 =?utf-8?B?M1NmcFg4b2tnRVhUNHFvNkh3VnpZMUt3RlAzR1NPaUtWcWVDQ01OYTZjY25q?=
 =?utf-8?B?NmE5eEdGdjBORUx2SWRrVFUyVjJ5TkUzY292NkhYVFFVaEsrYmdRcVcyNERL?=
 =?utf-8?B?TFhCVU5aL285bm5xT3ovQmlSQ1d4aGV1b3ZlY0p4djZIaXVGVDZkdFlXRWd4?=
 =?utf-8?B?Ynd1aXp4OC9aY09ILzlQQXVrSkNGMzVNNTg5YWJpRUxHRit0UklSUDhtTUE0?=
 =?utf-8?B?N2d1STVTT2ZrcGFrMVpXSm5JWm9jbktibGRab2ZHcCtMVkJlSVROVWJUdlZj?=
 =?utf-8?B?YWd1bVZLTk93WXZJRGx6WmhpVEZiK3k5YlR4UnFDcFlUbHQwSXRJMmhLazRZ?=
 =?utf-8?B?NVA1M2dveXpyb01LNGQ3aWQrekRxY1J4blBFaUhKMmpmcjliNzZ1Q3pWNnFF?=
 =?utf-8?B?dzN5YUtJM2p0V3A1UTFFV0RHMUY0SSttMmZWYzJrd1ZlTnh1c0MxWElqOCtp?=
 =?utf-8?B?bXRGNnVYWFpYNVYxWHlOL1lmVEZyQmtxbzJLOWNQNTk3ellIZ1BSNngwOCs0?=
 =?utf-8?B?OEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBA560F123C2994DA63D71F8D859D1E6@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1036b8-73f2-48d5-af55-08dcb0fd7e21
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2024 01:09:56.8688
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWClUuGDWsP2zBgyhwKGXxDKUsm9EZ6uW1d5BdLy8KuyemFLWuZy/pzcbmRYDBbdT3uVnVCH7nkm2V4kgZNS2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4230
X-Proofpoint-ORIG-GUID: hgKqkZJKpq31MZeSomFp8hjwNNqeVt7H
X-Proofpoint-GUID: hgKqkZJKpq31MZeSomFp8hjwNNqeVt7H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-30_21,2024-07-30_01,2024-05-17_01

SGkgTWFzYW1pLA0KDQo+IE9uIEp1bCAzMCwgMjAyNCwgYXQgNjowNOKAr0FNLCBNYXNhbWkgSGly
YW1hdHN1IDxtaGlyYW1hdEBrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgMjkgSnVs
IDIwMjQgMTc6NTQ6MzMgLTA3MDANCj4gU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4gd3JvdGU6
DQo+IA0KPj4gVXNlIHRoZSBuZXcga2FsbHN5bXMgQVBJcyB0aGF0IG1hdGNoZXMgc3ltYm9scyBu
YW1lIHdpdGggLmxsdm0uPGhhc2g+DQo+PiBzdWZmaXguIFRoaXMgYWxsb3dzIHVzZXJzcGFjZSB0
b29scyB0byBnZXQga3Byb2JlcyBvbiB0aGUgZXhwZWN0ZWQNCj4+IGZ1bmN0aW9uIG5hbWUsIHdo
aWxlIHRoZSBhY3R1YWwgc3ltYm9sIGhhcyBhIC5sbHZtLjxoYXNoPiBzdWZmaXguDQo+PiANCj4g
DQo+IF9rcHJvYmVfYWRkckBrZXJuZWwva3Byb2Jlcy5jIG1heSBhbHNvIGZhaWwgd2l0aCB0aGlz
IGNoYW5nZS4NCj4gDQoNClRoYW5rcyBmb3IgY2F0Y2hpbmcgdGhpcyEgSSB3aWxsIGZpeCB0aGlz
IGluIHRoZSBuZXh0IHZlcnNpb24uIA0KDQpTb25nDQoNCg0KDQoNCg==

