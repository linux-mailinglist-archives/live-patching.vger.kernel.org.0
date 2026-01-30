Return-Path: <live-patching+bounces-1947-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qF62AbkYfWkhQQIAu9opvQ
	(envelope-from <live-patching+bounces-1947-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:46:49 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89FD8BE82E
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 21:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 53EE83025298
	for <lists+live-patching@lfdr.de>; Fri, 30 Jan 2026 20:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39668329C7E;
	Fri, 30 Jan 2026 20:46:32 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from LO3P265CU004.outbound.protection.outlook.com (mail-uksouthazon11020085.outbound.protection.outlook.com [52.101.196.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB44308F36;
	Fri, 30 Jan 2026 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.196.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769805992; cv=fail; b=HLOlIelQQlkfvMVNG9iuiKdNpwptb3metXH8MJzYwESbMgzA+9z6tBinv75SQmHJHmhA+KIHLuSquWrn/TfqTS9Pe3maqHFqeeIFaD8nsQbW8IJo8Ycca6o/P/IxAsBf3ViBuRXPOb7amNV1yHN/3A2ad1/1fXZJCbGyE4xb34s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769805992; c=relaxed/simple;
	bh=v6sycoVBQtrAOSzYIT/FgJcp/witaL1WxXUOXLAdhF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ImaHmxwi0gqjXWLCs8ww0OffdKoiIJb0LLlzC/TyLZUOO6LNFJBJDqBxOTf07zxGd8KYawzIH6scIDVc2mqHIBPpWXnnvDkhLJPJd6eR0ZOnq95eaz/+KAsqmU/G6ZyT3onl8YTuv8ZAtC41nooCQrDtin11hJxNdr62Nu7pRYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com; spf=pass smtp.mailfrom=atomlin.com; arc=fail smtp.client-ip=52.101.196.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=atomlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=atomlin.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IlILapYVecO9qrLiJOoJt6oAFwTExnhiTlumDubCqxbXZz7YM/Wf/GVRW6QwGbyuI8DV65NMyk4cp/BCbke9EfAWrItceXbUoNOlZjB+sMvVkPDFHolOfKZ0WFRLnG/Daa+5Bal0OuhccB49X4iLrN/ere2VE5p+GdUTHVg8k2FC5G86prRMthWxJX+SXKIs3J8mxlqbJiQ8ZlBQlOGpow6tQv39GVrLdrKPs8FDo2QXkHqyPDouvM7C82/4FibzczzE4mOfMUkPZQzCT/J4UebSReFs++4EYRzSl/NdYoRkSsQAu/pDVvR7Xl/z6ElucrtOt/JhHwJTtwEa0d1oDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4v7oOc/Qacy+k2q/ONdPTB8/LMaAvRB9QVry6rBvAMg=;
 b=VYE00TxrLSj7fDrsrAvFnJpHRmqZFbUgfYNobx2DzaGjp8ojoQVIDgE46ZFgRjwsrMKdvFdIxwSQibMM48PVlX8YQmzgt93JLR6tBREZ9fKxicaaIHCc7Azr8tUFLmuGbFwJ7GYTm+3kkHUbHLnmGROx3prvfPzJqAGd1WjjvaPL4T56D8nqeQRJq4bukHw5UQKfj+KaTip6tfDgBincsUVzpukJ7Pua1eoeHJHu7ZI2MRPkhse0jpLqtD8QB8dBtH9ncGE/CKucPaSzDM19PVJ7F1hemXkxIKm8KrmB53Yvo7I32CcdBQNJrSQkCH6sydRTkyHDTJRdarEa/LiUWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=atomlin.com; dmarc=pass action=none header.from=atomlin.com;
 dkim=pass header.d=atomlin.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=atomlin.com;
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:70::10)
 by CWXP123MB3559.GBRP123.PROD.OUTLOOK.COM (2603:10a6:400:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 20:46:28 +0000
Received: from CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf]) by CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 ([fe80::de8e:2e4f:6c6:f3bf%2]) with mapi id 15.20.9564.008; Fri, 30 Jan 2026
 20:46:28 +0000
Date: Fri, 30 Jan 2026 15:46:24 -0500
From: Aaron Tomlin <atomlin@atomlin.com>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, live-patching@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Improve handling of the __klp_{objects,funcs}
 sections in modules
Message-ID: <qe6bxwov3hkii7dzwqjgs26m3pt6zbmoevw72voxry7ialaivv@q7mwkdjpnhpz>
References: <20260123102825.3521961-1-petr.pavlu@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="snljatwkeyosnopx"
Content-Disposition: inline
In-Reply-To: <20260123102825.3521961-1-petr.pavlu@suse.com>
X-ClientProxiedBy: BL1PR13CA0264.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::29) To CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:400:70::10)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CWLP123MB3523:EE_|CWXP123MB3559:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df2ba35-7a1e-4763-e868-08de6040a412
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MHlDb244VnpYNzVWQTh3M3Z5eE9YaUx4SXhCZFVNUjBLb2V1am9NaFE4amtV?=
 =?utf-8?B?V09scVB0S1c3QmhObzcxVDI2cEI1aGltdzVHU2VVKzdXb1l2cTdyVXdrQm9R?=
 =?utf-8?B?cjZudlg5Q3BZaGMrVlR0YWNsSWpjeHJ1cHora21pWUJLRVJyNndqK2liTTZ3?=
 =?utf-8?B?bFREMXFOZkgyOGRMM3JpamVTUk1sNzdwMmpNWkhndUNUNkQ0UUl0T09KNFQ3?=
 =?utf-8?B?K1VneVVSMG1jQm03akczODczMklnWjlzSjJMZXh0bk9aeERyL2dScnRvUUlM?=
 =?utf-8?B?RGFiY3FRNU90ZVREQjdIMXU1dTRVcUFIRWI0YTRiRC9IVUFxYnhCRVowa2E4?=
 =?utf-8?B?Z1pDSlZyVDBiL2x4LytVWGgyaFNnZHJPcXdmTGd4ZDhxUXFyU0tJdmc2akZt?=
 =?utf-8?B?cW0wcFJ5RXhNR3ZtNlR2KzRQWDZXMHRrVHplc1A0T0lyVm9JVlR1b3pxVnNo?=
 =?utf-8?B?ZzI4enQ1c2ZtUkYvT0lWWk1oNkNkL2RVdXorNU52SGRMRys0TjNMSVZuQ2V6?=
 =?utf-8?B?UEhIbFVnYWtPUVJOTDdiRGFCdFh4N2hrMkozTWlBY05tdm9WY1JnNTFzRDVB?=
 =?utf-8?B?dGtrZ2Y4YVNjclh0NzBFaStGRXFxOE9RYVR0NHVqbWxhWnRhVXphMzlNNVgx?=
 =?utf-8?B?Z1VHODRNdC82Y08zQjcrbHJROSttbjUzM0EyRmxHWDdjUTUrbUNwd1c5ZFJJ?=
 =?utf-8?B?anBNMUQ2RURKdEV5S1BxY0Q2K1VHbzJ5NEtZRkdqTWRERUorOUVKMzdJdG5K?=
 =?utf-8?B?L0pRbnBVdHBSNEtacTc5ZnBhQVMybFI4WkVBN1U0N2UvOGxEUk4ycnF5TkhF?=
 =?utf-8?B?US83R3dobjU5RG1PK0dNdFJmSDBzNS9aaGYyNVB4SnE1ZVF2VjAxYnFUcHZk?=
 =?utf-8?B?THNTa1BxWjVJc3Flbm1wdXpSRk5JT3lnQ3BnbmZRMmNJN3NPejVsSlhiLzM4?=
 =?utf-8?B?V3VvR0k5ekpiUERXbEpVZEFnWmtwT1Q2QUxJenhqL2t3c25pVGlEVzRxU0dl?=
 =?utf-8?B?djVJWVErbHJpOTNWdWNmUEkxV1NVb2IrRFNkOXh0VUd3anNUSkRQcDNFbXJm?=
 =?utf-8?B?anBPVmxkMDBlekNseWY2LzNiek5QNDFPS2xCdXdyY3dpSXhYMEU4OGtka3dm?=
 =?utf-8?B?VWNsY2k3NFVVeWdtaFd6WW9wVnRtbk9VT3R3QVpyc1RFOFN2eWFJTXRsbHhM?=
 =?utf-8?B?b0N3aW5BeFlOWXhuVFprL0xoaXM4VSszbjhXOHlFY2tOdmM2NmxNMHcwaEVh?=
 =?utf-8?B?c2VMaTR5SWx0S050MTlxYTlRd05PRit5NGpZVnhPMjlDTGxyaEdNS2ZBc3k3?=
 =?utf-8?B?SkgwWHFRd2MvZGNwZGRTM3IzRjBqTzdKT0pFdU5NV1BwTnowSHpLek1udFJp?=
 =?utf-8?B?c2Fub0xsTE1rTm5DOVpybkowZWROTG5pdGtmeW43VHF0c0VyQXAyaHg5cXlE?=
 =?utf-8?B?aG9hUVZPS3JFOHN4dk5XQjlrVHR3cytWNnFPQ1R4NkJGbnlCZ2NEQldXTTBn?=
 =?utf-8?B?NHBQQ0paU3hqZkZWSS9MTkVHcUtpRzcrb1hmREpXNDVGb1FNUCtzTXQ4RklN?=
 =?utf-8?B?S25ZYTBoZ2dBSEFRdW5CYzhkWGxSMHVFWGswbDFQSFRhRGNnWUQ2Zk9VN2hs?=
 =?utf-8?B?UUFwbTJXMFB4Z0ZQWmNPMjBGUG1PRUNqekxNOCt0WktFdUdnenh5T1U0QjVX?=
 =?utf-8?B?dVpsQjFCem5KWFJOU2pTQnRiWERSUzBCSm9NL29OT2RoR3Q5ZTNieWFVaGNV?=
 =?utf-8?B?QTJIUmJXZHl2c1M5di9JUWV5TmUxVGZRNExLeVpaMzFHQ3hwbHBzVkgxRXNr?=
 =?utf-8?B?WUU0d3g2QmJvTzRTdjU3NjZMMW5SVnBnQ2djaWw0dFVBZTRCWmlCdVpkYVVp?=
 =?utf-8?B?UlVPUVlPZGFYdVR1TWxrQWd6RHF0Z1NEaGVvOUx5a3lPd0pxQjZKN3psQWk2?=
 =?utf-8?B?dExWb3RieCtrRSt6dWhaZkJxdVRQdFZ0amZWbW9CYWNQUmJXT0dKd2J6NWpO?=
 =?utf-8?B?aDVJQVk1VENScnhPRkdxMXlMbWd0b0pCZjhhbWtNOUJVVkZpL0w4VVYwOXB5?=
 =?utf-8?B?SzEvMVM1UUhUMXM1S0U1QmJXc2ZhOWdhUW9mcTBVOVVLTmF4RW9wenpIMVZ4?=
 =?utf-8?Q?ERRxWuYhuIQcsYZkLG0V8JDTx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WG1OS0phTWJOd3gvRXY3V3BGQnluZFJFRjJCc3lNSytueCt6alhycDJxcXpR?=
 =?utf-8?B?cXNHdHQzd2c0UXM1SHB2d3Jod3pDd1Izc3VpczlQMHFUQW5KQkpOUWRidkZh?=
 =?utf-8?B?dTFtSEN3VzFPLy9IVm9Ld25iRzNaam9YRzFNOFg1UmJGeDFnWnFNMW5Eb09J?=
 =?utf-8?B?T3hTZU5RaERkNVA5K0d0SC96SGpCWGZZUVFZd1JQNnhBTnZ4NUpmZENGbkY5?=
 =?utf-8?B?cHRCU0tidTZzT2txV1dTRUtmQ29uWXhQZ3BFck9ob3dRQ1FMMy9BZVovWlB4?=
 =?utf-8?B?cDBxOTA3YXdVVFQ1Y01xSkVhYXJZNWlGdUZhU0hQTFpXcTlRT3JRVElDeTlJ?=
 =?utf-8?B?UnMzRC9FM0w5R3hLblQraTFhV2Rwd0hkYktEU1FzVmpicjVtZVZOYVVPRERJ?=
 =?utf-8?B?TUZHVFpSclVRN3JSeWNSeTMzNTNJeDZkaExsM1BvRy9oRURSSzBlekRidlJn?=
 =?utf-8?B?WThGMUpkYmNKMVIxVkQyWDJJREZOM2dPLzQ3QXJ1anNXTDkvYXVXNERWWVA3?=
 =?utf-8?B?eVYzbHFYS21iaFQ1VUpFVEVRU2hDZWdSTkRHaUFHdTFhTXZTSGtlOEVZdlFK?=
 =?utf-8?B?VDFxRnpFWlVkL29wRVVmbjQyWDUvT1dDUkpjVG03eFRpSjhjWjlqSkovNmVY?=
 =?utf-8?B?U0c5SU94VGtPZFB0RlQ3WTFaanFLK2dZQnhBTHhOczY4MVlHTlBtUnBlMklJ?=
 =?utf-8?B?eVZaUTRZWTZxRHR4dG1uYWUwUW5DeFYrVVpQWjFESkd5M0lWaExqZ0REeDM5?=
 =?utf-8?B?T0txWE1GMENsaTdlYnJiVmxEYlJ1S2d1Qlp1K0hZempRUUxhWnN3Wkc2emVx?=
 =?utf-8?B?RzdoSmkzY21BbVArQnJ0WmxxSDdYMCtRK2dhQ1paZVcxSW9KOGtBQ2dES0t3?=
 =?utf-8?B?Q3YrV1hRZThlTTdSbzhQTDBmNDRRT0F4OXlFY3ZMZkI0bTVNKzJZdDYrVTBr?=
 =?utf-8?B?UkIxY0FsZmdGMmhSZVJiTnV4ME1rcS9mVjVYMnVBRDNkNExjODRjQWorbjll?=
 =?utf-8?B?S1pKMjgzazVSSVNwb2NnTlUvNXp3QllLaGQvUWFrbWEwRktWckpCV2svdEU4?=
 =?utf-8?B?bGhxL3RGOU12ZnEyRTVFZlVlV2tRL0VOMUVCYWVEZjVzZmEzWkxDM2ZQa3RR?=
 =?utf-8?B?S3I1M3NET1Fmdk00MGRQeEs1U2VkeGNlWnA2MU5WUjN4RGc2Mlh1emxZdFlH?=
 =?utf-8?B?MWJOM3BKOElmbHFYUlU4Q1VLNjQvVlZ0d1hnWER0L0tQVmdoZWxqQWJwTGd0?=
 =?utf-8?B?NnV5QUlBUkNGNS9XUmlZOWUwTVlQK0RXcWtxMnFwWU9mZmZGUUNrbm02VUF3?=
 =?utf-8?B?VUxia1NwUUo3dzJvZDZoMkh4aTNqQWtIM0NOcnVvZSs3ak4vZlExbWJwempz?=
 =?utf-8?B?RVkzZFJEMms3ME14Nms3UVhxTlAyNXNXNTJBSE81TUFiTE1mellmWVNEV3ha?=
 =?utf-8?B?bjJja0U5Ly85UHFWV2s0dVJqWVEyRVhIMURNZUMxdDlqbkNNMHpLcG1IVzRq?=
 =?utf-8?B?Z2ZkNmNCSGh3Yk5hQmVWMEd4UmdLbFdPa0Z0MmdpbVI1YWlXbUtrbjc0a255?=
 =?utf-8?B?UStYQjRQOGNVaVpXZ1oyQ2JRU3ZrQ2JwV0lxZE5OQlRnZWJoWGx5bm9vSndJ?=
 =?utf-8?B?Y0FvYUExTTNtUUdDQ1lxdXZocC9WV0IzTmJXb1FyNEQydTV4dkpFWVBhYVFk?=
 =?utf-8?B?ak5WK3ZOL0grU1RqUThGdWNhMGRQcDg0NG9EWmxpZVBVU2Q5MlBwbDZOQ2J0?=
 =?utf-8?B?UUJNQU5lNTg2dnhkVkFTV0VkdXJZTjgwUGdrSTcxTDNTYzUvaHJZMmQyN2ty?=
 =?utf-8?B?VFBCY2lSQWcxNkNlNG1LckRSUXFlV1pWN09iM2puN1QxTS8rUVozRnc2SGNa?=
 =?utf-8?B?WEdKbzJIc2FvelViL0YyVCtFdDhXMlNZa1BQNUs1aFFWcUc3SWhYZEJNWGFz?=
 =?utf-8?B?eHprUWZ5cU1INFJUZWM4SjZRaUtaR25SOTg5Q050ajZMVVlZemt1ZGt3ZTlQ?=
 =?utf-8?B?Z2hnaU5VcHZkVmp0bnVXZms0NnpFODFUSzBNV2dDMDBLdGdvcWJZMFREL3J5?=
 =?utf-8?B?TkpoNUtoQlZ1VEhaTmFIR0ViNVdpQzlKam5acU1iSFZkMXhDdUZNNWZVWEQ1?=
 =?utf-8?B?ZjJySDJCaklMWmZkUzFYWnJzajlQRmJwdnpOZkZVcFVrYURBNEhTTDJKMDZE?=
 =?utf-8?B?UWtHcWF1V2JBcHd0SDRVRE9yblF0U2hoSC84WklhdVJIbXpGeEVKbnBMSWRF?=
 =?utf-8?B?SHpLQURGTTRJRlIrWDVLY092S2xlOVpVazN0NWk5NllJVXdFSk9ZUzArZTF4?=
 =?utf-8?B?V044Skc3SU9kVW0vaDd5U0RqKzNWbGNibGE0bnR1OXAreTFXZWp2QT09?=
X-OriginatorOrg: atomlin.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df2ba35-7a1e-4763-e868-08de6040a412
X-MS-Exchange-CrossTenant-AuthSource: CWLP123MB3523.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 20:46:28.2293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: e6a32402-7d7b-4830-9a2b-76945bbbcb57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rO6+anZU8iDkHmXRulKcjirXrgxzWv5NMdIZB0I3GBUc62NTbnhy6Zpi05QonbTC598+j+BasCmpkzHjuAdqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB3559
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.06 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1947-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[atomlin.com];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[atomlin@atomlin.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,atomlin.com:email]
X-Rspamd-Queue-Id: 89FD8BE82E
X-Rspamd-Action: no action

--snljatwkeyosnopx
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 0/2] Improve handling of the __klp_{objects,funcs}
 sections in modules
MIME-Version: 1.0

On Fri, Jan 23, 2026 at 11:26:55AM +0100, Petr Pavlu wrote:
> Changes since v2 [1]:
> - Generalize the helper function that locates __klp_objects in a module
>   to allow it to find any data in other sections as well.
>=20
> Changes since v1 [2]:
> - Generalize the helper function that locates __klp_objects in a module
>   to allow it to find objects in other sections as well.
>=20
> [1] https://lore.kernel.org/linux-modules/20260121082842.3050453-1-petr.p=
avlu@suse.com/
> [2] https://lore.kernel.org/linux-modules/20260114123056.2045816-1-petr.p=
avlu@suse.com/
>=20
> Petr Pavlu (2):
>   livepatch: Fix having __klp_objects relics in non-livepatch modules
>   livepatch: Free klp_{object,func}_ext data after initialization
>=20
>  include/linux/livepatch.h           |  3 +++
>  kernel/livepatch/core.c             | 19 +++++++++++++++++++
>  scripts/livepatch/init.c            | 20 +++++++++-----------
>  scripts/module.lds.S                |  9 ++-------
>  tools/objtool/check.c               |  2 +-
>  tools/objtool/include/objtool/klp.h | 10 +++++-----
>  tools/objtool/klp-diff.c            |  2 +-
>  7 files changed, 40 insertions(+), 25 deletions(-)
>=20
>=20
> base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
> --=20
> 2.52.0
>=20

Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>

--=20
Aaron Tomlin

--snljatwkeyosnopx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEeQaE6/qKljiNHm6b4t6WWBnMd9YFAml9GKAACgkQ4t6WWBnM
d9b9tw//coNkUH59kvrPeM4EW4Z8m2RemQBsA8sDJjPI8KVeSd1hq5LyHELZDeKb
5TI2OZ5nP+ogMyBmrMRpSQl6tin1q9oqFrFYBlzXBsR5JF/pmU1rvQT6npBnqmir
W6QySGktazzHMoRBem+LYMlGR+B1kMqDTsrKTI4FmUs/sq1xIrXpY0xqNL/4cmt3
1ThtsL4qtkxtdAI96mur3cVA6YuF6spQeJslw8ZS0HZ44Re8i61sXfxtk41XqRID
WGjjdddjnjRAOTKlDuzsRf/Lk+nizB10pgUx3Ve46q3JV63ZxsrjfVaEl3SCkyOm
4Mp4Opuv86uqUmChtmxAk9c5sOqZiix9SuMBg3ldwNLrpdRxfLiW34IwvEZOYiMu
WQ/hsmqdM40a6vmfJfYv8j2TV3plQaTriVyLCWoa9rjJI/TvbTHt26za0lU+Br+I
XM3KKKLuE8bckOSVaOO168brWPq3l10aejPXOo/juVoYUlYTLKqQLKIybbeHvFCO
eVlxp98fgxOxBsH2cc48hOVHBOaR31RmDs7CiqCW1ZEbmBGwf7A2eRem1Tq7xl09
9nYcrdNEFObS6CesEz7V9YXrxo0y1SZ5IUvnQcsXwuawBsXpA8NquaSXaT0+EYIy
JHrPz0Cvlrgt4y+AJ4wP08vSnGYvjhN334aS7+zHrsr+7LIqVbw=
=y8FY
-----END PGP SIGNATURE-----

--snljatwkeyosnopx--

