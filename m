Return-Path: <live-patching+bounces-478-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C9094D4DC
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 18:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66BCF1C20D96
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 16:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEFED1CAAC;
	Fri,  9 Aug 2024 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="QYzDXXbB"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEF01C6A5;
	Fri,  9 Aug 2024 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221632; cv=fail; b=jr8Hk5Xx5N8Gnp+RRiyIVp3zUF5EfWsoxh0Uhm7bRYIYfYLvGnCujMFiQeO5ptZbwUE0cMvVV+kao1oA7IGjhKrjc99cg6ciGJTmM17RGVOK1+LxnjdrBckoO7ePd3Cw4TE0UevuO4QU/shiP89EJ2t4paABG2mPaEjoVmAaDe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221632; c=relaxed/simple;
	bh=glRV9MHvjb9VBz+yEI/5IVVmBvojWZe0eCAX741oAHg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=P4pSFrrWPdMjwjw23RRxq7+keLBbWnW70i3czNPkauME5LXiBcy2N1VORbnk+3Ug7Epn2Uzn4Cu8okamhspbtSapfzJz05BPRPzietu7GiCKBirbSmMH+Lp79n1VEvddMxwJgX0qZQSiOAW2+UMJoXwZ6ovaOrvRtu3hugXnor8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=QYzDXXbB; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 479E3MM2025852;
	Fri, 9 Aug 2024 09:40:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=glRV9MHvjb9VBz+yEI/5IVVmBvojWZe0eCAX741oAHg
	=; b=QYzDXXbBi+3OJGgcOF2lvTIW999yP5Sz1+GfEcBhu6hTY9t8CV7qryYSmrC
	8dv/oxCXoKmampgr/D0RkoH7Abm2GcDAvnbIeGKII7nqIhZyCIyoshwH9xB7CHvJ
	X3EEXHqAF236ry3mZc8C0fcha+GR6oGD3v/mzXKovxbqlSUnpMpMdtsFSqcqE32n
	7MhK1TYhQOX351R7GxpT6R3qszswyM8hFKhbAoiEGVkHFylLJ8FNyxSx9C+XWVv9
	cUXi07y8jbL2p2FCdkvaJcxfiQt4gw3bnauLmk431j3P5/gPOK6sMWLnRmLQoC3R
	TIkX87awopvm4nCism0P4W4pnEQ==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40wmhns5g3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Aug 2024 09:40:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zFx8BNd/EnUAQtkuXF2TIOvr7R5uhnqVBJbslqymkqXp25c/urLhOn1tntAtj7GNZdnhkje3zusPjJkGt4024t7LgWxSeBMULv4UV2DLaM673algycawkiKgjKUWLvKeeTB4Ng7f5kpZ4WucwKmQ+7eAMjLvf5G62BtjfJ/k7//vAFTxaYhW59sb1KAmqZAmndtC/OlJZqrE3X1Mmz80fw5QferL2DEKLeJRZR9Nn4SvlbQXAUVa727/cmGxBsb0sQsSm089k+b5uSULkGGIMcjL6mHxSpJ9xL43/L+J/91Y4+Fe0ZTMZfB+cvV2FrCc2gojM/22lnNLg5SAA0RXqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glRV9MHvjb9VBz+yEI/5IVVmBvojWZe0eCAX741oAHg=;
 b=M44/PHJxf9tdnR9msQDBG0PyAcxylc5w11G4ARa82xAXrCbpsSs9vKgx4ds52aKvAaXVm8RGtmEX5ZMAUwm7lHgum0cAVER89I5GfIOevrJa479cWU3/IBK2EwQhxSkKbWkO1fMZsL+4UlUiMp9Z1As+1ObKNujAhHYjGSP1RNU7Ypyui8zOlrzoK8lcdhAHVGuUK95t/jMuLfTxvqx+0QBSwBEkK0mrRMpd7OmJMo0ImBg3Nv9NnFpreXJNzZyVNNnfjoXy/NSbG79wjFva7O+8sFNy6s7CD3HbhsvSYvBURr6GP60d8oCu1tvl762HOtyiOZur7M3aDSljtbDlTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BY3PR15MB4897.namprd15.prod.outlook.com (2603:10b6:a03:3c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 16:40:25 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.015; Fri, 9 Aug 2024
 16:40:25 +0000
From: Song Liu <songliubraving@meta.com>
To: Alessandro Carminati <alessandro.carminati@gmail.com>
CC: Petr Mladek <pmladek@suse.com>, Song Liu <songliubraving@meta.com>,
        Sami
 Tolvanen <samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAFrMgIAAWCcAgADc1ACAAVU2gIAArTkA
Date: Fri, 9 Aug 2024 16:40:25 +0000
Message-ID: <AA015194-A0D0-426C-A3B7-11C5B7CA941A@fb.com>
References: <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
 <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
 <CAPp5cGRZZxxxMez4B5dqjQCD6307K==5-aTLfqDmZu2Ui9mEmQ@mail.gmail.com>
In-Reply-To:
 <CAPp5cGRZZxxxMez4B5dqjQCD6307K==5-aTLfqDmZu2Ui9mEmQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BY3PR15MB4897:EE_
x-ms-office365-filtering-correlation-id: 0115234b-495a-4f72-aa8c-08dcb891f82e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?K3dkOXZWT0lxSmVBMzd0VmtwMVhNeDFNNVRqdzgxMURSbFF3SXNQS3hxQ2d2?=
 =?utf-8?B?U0taemxrYmNlMzd4ci9ERHIwbUlNWE9ySUhhYy9vRlN6QmRjRmozWnVRS0hO?=
 =?utf-8?B?djUwaWI4THhsL1FISTE2eDlnbkFwQ2xXdER5enpzUU9hQUJGRGZPekZOcFFr?=
 =?utf-8?B?U1orOW5rdVU1eFBWOVBvdGVlOG1xUUFubEJKYkN2SlBXdnk2Z0dJMHNRQmQv?=
 =?utf-8?B?cDRMV05lTlFnclJCUnVOVytKUDRzd3ZDc2xEQjc4cDNsOExVbmpDcDQxZEo5?=
 =?utf-8?B?bVdRSVNyREhVTXZ6NkRzS1ZSOGVrditKUnhpZ09mV1BDVGU1eXF3d2FSZlpK?=
 =?utf-8?B?bVYrTDgxV0sxbWRkNis2ZXVKazhsZVAwMCsyNFFmRm5CREppdVJ0WS9QRzZv?=
 =?utf-8?B?MXRUcmF3eURMNUpJNmZlcDNBWlpHZGZOMzJDSWJUY29GNTZpZ1hMU0ZqdUcx?=
 =?utf-8?B?dnY1eFMrTVJocmR5ekFGK285NVlmVFRqdWRaYkJ1UUppMW9TRE5INjRQV0JH?=
 =?utf-8?B?OFBOblBUN1JwWnhNZnNvbFQ3MTY4SHZrYUdiSHovMUFaVHkreGxzYUEzemJm?=
 =?utf-8?B?OFYwVDJsazNDeDVvNUd0ZG1NaUh5bnN2THV4RGh0Y1ZnK2VIZlUyOWpOWFVJ?=
 =?utf-8?B?cHM2MG94d3FWVkVmRkNSc1kxc0hpT3VBb3V2QUsxblpucEFJTTYvQ3IwTDhL?=
 =?utf-8?B?K2lJVmhSY1JkTTd1Um5TNDZETU91UmEwWFRlOW15Y3ZRUjVabTVwZFowYyt1?=
 =?utf-8?B?eFpVYWd2Z0FYSkhYajYrc2NWcFJHeXovTFErWVR5ZTQxZkFaT0FkZkhBeG5i?=
 =?utf-8?B?a0hCa3N4cmt3UUN3WXg4MThnazdsZHRDM0doSTVYM2FmRC9yU054bW42MmpX?=
 =?utf-8?B?ZENKZW5GRmVLcnpFM2Q5WnA0RWpKb3VkYjFIU0c1N0lBSEdnT1pkaHR0clQ2?=
 =?utf-8?B?WnZwb3MrM1Y0WnovVHpFZXJKWTdINUxEekFHUmxnYTNaL1dab2ZqcVl5QjZi?=
 =?utf-8?B?SEt4VFJxeFYxcnNOYnY5UDgyNGoxVzhvcExMdVUxMEw1d1Uya3l2ZlIxdXFn?=
 =?utf-8?B?Y0VFL3VONERRa1YxMkNZV0liZ21ILy9wZ1BtNk5VY2I1R3N5TkU4QlpVWVE1?=
 =?utf-8?B?dzZzaFBleHRPeUg5K3dZenZCYWtjMGc2eGJIdU5WY082bjRHODhsa09nZ3Jz?=
 =?utf-8?B?YzJ1RUtld1dHM3lXYjZpQ3NOeVI4T0I0dmtJYkdsSEh1NXhKWU43a0pnWllm?=
 =?utf-8?B?WWVzSTFvc2RHblplV3NHdlpSQi9ra3RMc2JBT1lNQmZEbHViUzdRRnAzUXRO?=
 =?utf-8?B?dkFOQ2VJUTlWdTQ4QU1ML1BmeTJVOW9oMmE1SjRaVkdONmFOUzEwa3Y5cmc5?=
 =?utf-8?B?dkxhbFdqZDlVcUdybzhRc2hVQitWcThodnAxenJwdCtVYW9qQ1FmeEN1Tjh5?=
 =?utf-8?B?SGxtd21sOHFPQmczekViZ0M3TnRpTHZDM3RxV2l4Y1NxR0dNTVAvNWpOSkhO?=
 =?utf-8?B?Y1VQRjJ1TFFMQWt5Y3hZTEl6RkxnaE9Za3dUV2I1WkxUUEJEaDZEWDY1WWdJ?=
 =?utf-8?B?cFV5WVdxZitWY2MyNUNPU3RzRWtkNkQzYk83bXEyTTMxNEFsbVdPc3pZcXpC?=
 =?utf-8?B?V1JhOTFkTHJYeDBtK1B4TG9DK1FQeXhzL3dDY3FpUW12QmYvaVZNb1Zudjcx?=
 =?utf-8?B?QXpTd3IvSlNiYzFMK2hWS2Q4WCs4UUVpWEFaVDdxK3lqdW93ZHNNNUdjQzZH?=
 =?utf-8?B?ZmFQVFpid3Q0dDNJYU51VGFSbkVMQmJSV1BkclVxNlEwSy9hSGc0dTFDZkRO?=
 =?utf-8?Q?fme9TMp5twIu6crCVW55IcJSd/zkX6HKjFoDk=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WTZtWjkrUENxeHVLSmI2UmcyUThXd1p0NmNyWDlsSU00UHRYbGRNSmlTSlYv?=
 =?utf-8?B?dHZDbHdYWDFQQUNYd0JTd2YrWHl3YWZYUktLMHR1d0pDSmE5cE8zdWhiNVhw?=
 =?utf-8?B?eTBoYzFTcVZiaExqMG5XT1NiMGZDcTU1RTBCcTdmNGlxc2NEZ3J6Yk9DSHVs?=
 =?utf-8?B?VzNjOTMxYWZlZXo4REFtR3NaODNabFdTcmhwdEtPcGJoWVBrRFo5RGRxZ3Q5?=
 =?utf-8?B?MzY0QWVscmJkTlFJYk5RNjlhL0pPeHptRE85endmcjMwVW5Eb05UZ1pGWlVm?=
 =?utf-8?B?ajFSb2dGM2RJYkh4YkVod2hNbnRyekNyQlN3b3crcFZZbnNFOTFRU3BRQzY5?=
 =?utf-8?B?ZnJweFFjV0hLcHlNd00vbjNKeTVLek9rcTFGTkpPK0I3cG1JQ2FFTUNlTm44?=
 =?utf-8?B?c284Ni8wYUpBNVVBTmFTMEp5Mk1kSFRzNUw3MGVraVFFSFFYTHRDUTlPR05y?=
 =?utf-8?B?MituSnJuSENkcFFreXBMUzd4L1VnZWhIelVzamxBekZNUGtQQVJ5QW82OEUz?=
 =?utf-8?B?THBRTWVXcWpFRGo5cEcxWW5MQm5Eb2ZaaERuVTdvREdrV2FUOXYvOWtDektU?=
 =?utf-8?B?VFJvcDJBdzJuNFQxM1lNb3FqMVBpRjZNL0JOUXNhMzZhbHllT20vQlgvcnBH?=
 =?utf-8?B?NCttbDBpcHVaY3htb0dKT1hobmNvbE81dm51UE11THJ4a2lyUGRxRkRpQkgr?=
 =?utf-8?B?WUdKZ0NEa0kxRkNQK1p6U3dySXpsWjNYdnZrTWJPTU1uWlJIN3JoSVh0YWgr?=
 =?utf-8?B?YnNJZVM4b0NtOUpseGZmV2xwWmZYV2M5QnhoaURzUUR5clY2SWc0eTg3NHJM?=
 =?utf-8?B?b2xsdEE4YVdMNVJOSHBtTUUwMEtjai9SYUx6dTNXRkRLK3YwNEJBYXl0NGNQ?=
 =?utf-8?B?WUxuaTFyTHErK1VVM0h5NXdYZ3Z5VktPVFJSZVZGMVJlcjFTdkdBUGFJNWxC?=
 =?utf-8?B?Z0VqV1h3dUNwZGptZm4waStQUUdzNTdPdGJtd0NJMys3dzRCNWpvTnNOcEVv?=
 =?utf-8?B?aFI0dWZ6UHBNbHhNWG93RTJTUjlObzFQUnBGN2RLNHJRcnBrWjdoekJRdjBX?=
 =?utf-8?B?NXNhRjRURTYzUzlqYTNKY29Qc0JLRnhGS05ROG9HSHdiMVo5TS8rdkdGRWlO?=
 =?utf-8?B?UTBkWE9wRVlPU0pCVEVoQ1VoVytmSllZVTRiblhpbXFETU9pZTBDNUI2d25x?=
 =?utf-8?B?Z2p5T0JtU0RjaTRiR3dJTE8xWnl5ZFVXNDhJNi9LSDFjYnduRlZuTEd0YjZv?=
 =?utf-8?B?MHV0c1RBUEtHUVp0akNTNGRybGtRSnU2NWd0bFNLcXdScDhDU2JaRDlNOW1D?=
 =?utf-8?B?UG14bThmb0FjWHgyS3ZHQWZVekFaS3FGeWY4NlVZTzY0YjZrV1JDemlxUzE1?=
 =?utf-8?B?Z2V0TmJHUjdrTng5c01FR2lydjRpcUkwU1dvbFVHaTRkb1ZEUk9WcnZ4UklL?=
 =?utf-8?B?OC9QNGNkcUdlNG9mSFRQdlA3NTkxKzZrRFhpR3FicXgrRVZCMnl3ZGNTMmJz?=
 =?utf-8?B?YngzakxnVFRSZUlhMHA4WDhFZXNUdG5xUzRReXhRcWIrMWVNeWlzZUZqRFMv?=
 =?utf-8?B?Z0FqZUhraFg5T2orWXZHOG5EM3ZaVzFEbkxwYVZMYlZDazExUEtZY01hZzJD?=
 =?utf-8?B?UDF2ZkdRcGlxaUVPZDZBekZZbmNUcHZ4U1dIa3p2ZzhpVE5USW9LRU5SVEZU?=
 =?utf-8?B?VEtnNmVrRGlrMDMxZHRuUmwwR29VK2VnTDNjU1NGSWdDa011VXVWZmNGR3dt?=
 =?utf-8?B?b2N2Tk9CT3Jtc2hpVTBLRUk2a0NSWHBZanIxUHV0ZCtxcXZNUW1oRHQ4dWVF?=
 =?utf-8?B?VWJpa2U4TEMvWnQ5SThuSjF1aWVPaTB0Q1ZnSUVIUmRxRFJQYTBnbFE3UXVn?=
 =?utf-8?B?WFFWdnEvQU9zQkdOZDhTMUQvZXlvbTl3WSt2bGZOU1FRRUV1Y2RwK2UvT1Qw?=
 =?utf-8?B?Ymh0UXhzNnBnYnExRWpEazZKcUVJUE9WdDI3am95NWtYMVdtcHNxUWNXU1Fm?=
 =?utf-8?B?cWk4YTNKZjZoeEs3YkIwOXVHcWlBVXlaa0lLeUhCY0hEUmk1Qk1OdDdUZUFB?=
 =?utf-8?B?QzBTeFZ2ekxkYWRHRElyUzhMNk9QSmJkaVpWbTk2MkFwYUdpVEx4TXZQaUFY?=
 =?utf-8?B?T2h4YWgxWG55bXMrMVZSOE9KcHNCQVp0ZURIKzQwVTZkMEMwaHlFMDZoNlpq?=
 =?utf-8?B?ekUxRGZPRXhnK01IeDRxYWx2MjFMZVhqcmZEMXA4STBPenpVRG1tendUZ0ZM?=
 =?utf-8?B?c2Zwb3hPTzhndmEzK040T1FZMHl3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0D01EF7DCE6F54BAA4A2AE4632A16C0@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0115234b-495a-4f72-aa8c-08dcb891f82e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 16:40:25.2853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OtLIaDyQs6/MaW++P3M2ypkayZgGLfWlWPSEGfGi5naEVpQxAIhMuAAzpyAYZHOFdNfCLK9lSmtuhPMxdh3DYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4897
X-Proofpoint-ORIG-GUID: GxKoFi5CFOiSmz9owniRfvvKP9MWKjro
X-Proofpoint-GUID: GxKoFi5CFOiSmz9owniRfvvKP9MWKjro
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-09_13,2024-08-07_01,2024-05-17_01

SGkgQWxlc3NhbmRybywNCg0KPiBPbiBBdWcgOCwgMjAyNCwgYXQgMTE6MjDigK9QTSwgQWxlc3Nh
bmRybyBDYXJtaW5hdGkgPGFsZXNzYW5kcm8uY2FybWluYXRpQGdtYWlsLmNvbT4gd3JvdGU6DQo+
IA0KPiBIZWxsbywNCj4gc29ycnkgdG8gam9pbiBsYXRlIGF0IHRoZSBwYXJ0eS4NCj4gDQo+IEls
IGdpb3JubyBnaW8gOCBhZ28gMjAyNCBhbGxlIG9yZSAxMTo1OSBQZXRyIE1sYWRlayA8cG1sYWRl
a0BzdXNlLmNvbT4NCj4gaGEgc2NyaXR0bzoNCj4+IA0KPj4gT24gV2VkIDIwMjQtMDgtMDcgMjA6
NDg6NDgsIFNvbmcgTGl1IHdyb3RlOg0KPj4+IA0KPj4+IA0KPj4+PiBPbiBBdWcgNywgMjAyNCwg
YXQgODozM+KAr0FNLCBTYW1pIFRvbHZhbmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4gd3Jv
dGU6DQo+Pj4+IA0KPj4+PiBIaSwNCj4+Pj4gDQo+Pj4+IE9uIFdlZCwgQXVnIDcsIDIwMjQgYXQg
MzowOOKAr0FNIE1hc2FtaSBIaXJhbWF0c3UgPG1oaXJhbWF0QGtlcm5lbC5vcmc+IHdyb3RlOg0K
Pj4+Pj4gDQo+Pj4+PiBPbiBXZWQsIDcgQXVnIDIwMjQgMDA6MTk6MjAgKzAwMDANCj4+Pj4+IFNv
bmcgTGl1IDxzb25nbGl1YnJhdmluZ0BtZXRhLmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+PiBE
byB5b3UgbWVhbiB3ZSBkbyBub3Qgd2FudCBwYXRjaCAzLzMsIGJ1dCB3b3VsZCBsaWtlIHRvIGtl
ZXAgMS8zIGFuZCBwYXJ0DQo+Pj4+Pj4gb2YgMi8zIChyZW1vdmUgdGhlIF93aXRob3V0X3N1ZmZp
eCBBUElzKT8gSWYgdGhpcyBpcyB0aGUgY2FzZSwgd2UgYXJlDQo+Pj4+Pj4gdW5kb2luZyB0aGUg
Y2hhbmdlIGJ5IFNhbWkgaW4gWzFdLCBhbmQgdGh1cyBtYXkgYnJlYWsgc29tZSB0cmFjaW5nIHRv
b2xzLg0KPj4+Pj4gDQo+Pj4+PiBXaGF0IHRyYWNpbmcgdG9vbHMgbWF5IGJlIGJyb2tlIGFuZCB3
aHk/DQo+Pj4+IA0KPj4+PiBUaGlzIHdhcyBhIGZldyB5ZWFycyBhZ28gd2hlbiB3ZSB3ZXJlIGZp
cnN0IGFkZGluZyBMVE8gc3VwcG9ydCwgYnV0DQo+Pj4+IHRoZSB1bmV4cGVjdGVkIHN1ZmZpeGVz
IGluIHRyYWNpbmcgb3V0cHV0IGJyb2tlIHN5c3RyYWNlIGluIEFuZHJvaWQsDQo+Pj4+IHByZXN1
bWFibHkgYmVjYXVzZSB0aGUgdG9vbHMgZXhwZWN0ZWQgdG8gZmluZCBzcGVjaWZpYyBmdW5jdGlv
biBuYW1lcw0KPj4+PiB3aXRob3V0IHN1ZmZpeGVzLiBJJ20gbm90IHN1cmUgaWYgc3lzdHJhY2Ug
d291bGQgc3RpbGwgYmUgYSBwcm9ibGVtDQo+Pj4+IHRvZGF5LCBidXQgb3RoZXIgdG9vbHMgbWln
aHQgc3RpbGwgbWFrZSBhc3N1bXB0aW9ucyBhYm91dCB0aGUgZnVuY3Rpb24NCj4+Pj4gbmFtZSBm
b3JtYXQuIEF0IHRoZSB0aW1lLCB3ZSBkZWNpZGVkIHRvIGZpbHRlciBvdXQgdGhlIHN1ZmZpeGVz
IGluIGFsbA0KPj4+PiB1c2VyIHNwYWNlIHZpc2libGUgb3V0cHV0IHRvIGF2b2lkIHRoZXNlIGlz
c3Vlcy4NCj4+Pj4gDQo+Pj4+PiBGb3IgdGhpcyBzdWZmaXggcHJvYmxlbSwgSSB3b3VsZCBsaWtl
IHRvIGFkZCBhbm90aGVyIHBhdGNoIHRvIGFsbG93IHByb2Jpbmcgb24NCj4+Pj4+IHN1ZmZpeGVk
IHN5bWJvbHMuIChJdCBzZWVtcyBzdWZmaXhlZCBzeW1ib2xzIGFyZSBub3QgYXZhaWxhYmxlIGF0
IHRoaXMgcG9pbnQpDQo+Pj4+PiANCj4+Pj4+IFRoZSBwcm9ibGVtIGlzIHRoYXQgdGhlIHN1ZmZp
eGVkIHN5bWJvbHMgbWF5YmUgYSAicGFydCIgb2YgdGhlIG9yaWdpbmFsIGZ1bmN0aW9uLA0KPj4+
Pj4gdGh1cyB1c2VyIGhhcyB0byBjYXJlZnVsbHkgdXNlIGl0Lg0KPj4+Pj4gDQo+Pj4+Pj4gDQo+
Pj4+Pj4gU2FtaSwgY291bGQgeW91IHBsZWFzZSBzaGFyZSB5b3VyIHRob3VnaHRzIG9uIHRoaXM/
DQo+Pj4+PiANCj4+Pj4+IFNhbWksIEkgd291bGQgbGlrZSB0byBrbm93IHdoYXQgcHJvYmxlbSB5
b3UgaGF2ZSBvbiBrcHJvYmVzLg0KPj4+PiANCj4+Pj4gVGhlIHJlcG9ydHMgd2UgcmVjZWl2ZWQg
YmFjayB0aGVuIHdlcmUgYWJvdXQgcmVnaXN0ZXJpbmcga3Byb2JlcyBmb3INCj4+Pj4gc3RhdGlj
IGZ1bmN0aW9ucywgd2hpY2ggb2J2aW91c2x5IGZhaWxlZCBpZiB0aGUgY29tcGlsZXIgYWRkZWQg
YQ0KPj4+PiBzdWZmaXggdG8gdGhlIGZ1bmN0aW9uIG5hbWUuIFRoaXMgd2FzIG1vcmUgb2YgYSBw
cm9ibGVtIHdpdGggVGhpbkxUTw0KPj4+PiBhbmQgQ2xhbmcgQ0ZJIGF0IHRoZSB0aW1lIGJlY2F1
c2UgdGhlIGNvbXBpbGVyIHVzZWQgdG8gcmVuYW1lIF9hbGxfDQo+Pj4+IHN0YXRpYyBmdW5jdGlv
bnMsIGJ1dCBvbmUgY2FuIG9idmlvdXNseSBydW4gaW50byB0aGUgc2FtZSBpc3N1ZSB3aXRoDQo+
Pj4+IGp1c3QgTFRPLg0KPj4+IA0KPj4+IEkgdGhpbmsgbmV3ZXIgTExWTS9jbGFuZyBubyBsb25n
ZXIgYWRkIHN1ZmZpeGVzIHRvIGFsbCBzdGF0aWMgZnVuY3Rpb25zDQo+Pj4gd2l0aCBMVE8gYW5k
IENGSS4gU28gdGhpcyBtYXkgbm90IGJlIGEgcmVhbCBpc3N1ZSBhbnkgbW9yZT8NCj4+PiANCj4+
PiBJZiB3ZSBzdGlsbCBuZWVkIHRvIGFsbG93IHRyYWNpbmcgd2l0aG91dCBzdWZmaXgsIEkgdGhp
bmsgdGhlIGFwcHJvYWNoDQo+Pj4gaW4gdGhpcyBwYXRjaCBzZXQgaXMgY29ycmVjdCAoc29ydCBz
eW1zIGJhc2VkIG9uIGZ1bGwgbmFtZSwNCj4+IA0KPj4gWWVzLCB3ZSBzaG91bGQgYWxsb3cgdG8g
ZmluZCB0aGUgc3ltYm9scyB2aWEgdGhlIGZ1bGwgbmFtZSwgZGVmaW5pdGVseS4NCj4+IA0KPj4+
IHJlbW92ZSBzdWZmaXhlcyBpbiBzcGVjaWFsIEFQSXMgZHVyaW5nIGxvb2t1cCkuDQo+PiANCj4+
IEp1c3QgYW4gaWRlYS4gQWx0ZXJuYXRpdmUgc29sdXRpb24gd291bGQgYmUgdG8gbWFrZSBtYWtl
IGFuIGFsaWFzDQo+PiB3aXRob3V0IHRoZSBzdWZmaXggd2hlbiB0aGVyZSBpcyBvbmx5IG9uZSBz
eW1ib2wgd2l0aCB0aGUgc2FtZQ0KPj4gbmFtZS4NCj4+IA0KPj4gSXQgd291bGQgYmUgY29tcGxl
bWVudGFyeSB3aXRoIHRoZSBwYXRjaCBhZGRpbmcgYWxpYXNlcyBmb3Igc3ltYm9scw0KPj4gd2l0
aCB0aGUgc2FtZSBuYW1lLCBzZWUNCj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzEy
MDQyMTQ2MzUuMjkxNjY5MS0xLWFsZXNzYW5kcm8uY2FybWluYXRpQGdtYWlsLmNvbQ0KPj4gDQo+
PiBJIHdvdWxkIGFsbG93IHRvIGZpbmQgdGhlIHN5bWJvbHMgd2l0aCBhbmQgd2l0aG91dCB0aGUg
c3VmZml4IHVzaW5nDQo+PiBhIHNpbmdsZSBBUEkuDQo+IA0KPiBrYXNfYWxpYXMgaXNuJ3QgaGFu
ZGxpbmcgTFRPIGFzIGVmZmVjdGl2ZWx5IGFzIGl0IHNob3VsZC4NCj4gVGhpcyBpcyBzb21ldGhp
bmcgSSBwbGFuIHRvIGFkZHJlc3MgaW4gdGhlIG5leHQgcGF0Y2ggdmVyc2lvbi4NCj4gSW50cm9k
dWNpbmcgYWxpYXNlcyBpcyB0aGUgYmVzdCBhcHByb2FjaCBJIGZvdW5kIHRvIHByZXNlcnZlIGN1
cnJlbnQNCj4gdG9vbHMgYmVoYXZpb3Igd2hpbGUgYWRkaW5nIHRoaXMgbmV3IGZlYXR1cmUuDQo+
IFdoaWxlIEkgYmVsaWV2ZSBpdCB3aWxsIGRlbGl2ZXIgdGhlIHByb21pc2VkIGJlbmVmaXRzLCB0
aGVyZSBpcyBhIHRyYWRlLW9mZiwNCj4gcGFydGljdWxhcmx5IGFmZmVjdGluZyBmZWF0dXJlcyBs
aWtlIGxpdmUgcGF0Y2hpbmcsIHdoaWNoIHJlbHkgb24gaGFuZGxpbmcNCj4gZHVwbGljYXRlIHN5
bWJvbHMuDQo+IEZvciBpbnN0YW5jZSwga2FsbHN5bXNfbG9va3VwX25hbWVzIHR5cGljYWxseSBy
ZXR1cm5zIHRoZSBsYXN0IG9jY3VycmVuY2UNCj4gb2YgYSBzeW1ib2wgd2hlbiB0aGUgZW5kIGFy
Z3VtZW50IGlzIG5vdCBOVUxMLCBidXQgaW50cm9kdWNpbmcgYWxpYXNlcw0KPiBkaXNydXB0cyB0
aGlzIGJlaGF2aW9yLg0KDQpEbyB5b3UgdGhpbmsgd2l0aCB2MyBvZiB0aGlzIHNldCBbMV0sIGxp
dmUgcGF0Y2hpbmcgc2hvdWxkIGJlIGZpbmU/IFRoZQ0KaWRlYSBpcyB0byBsZXQga2FsbHN5bXNf
bG9va3VwX25hbWVzKCkgZG8gZnVsbCBuYW1lIG1hdGNoLCB0aGVuIGxpdmUNCnBhdGNoaW5nIGNh
biBmaW5kIHRoZSByaWdodCBzeW1ib2wgd2l0aCBzeW1ib2wgbmFtZSArIG9sZF9zeW1wb3MuIA0K
RGlkIEkgbWlzcyBzb21lIGNhc2VzPw0KDQo+IEknbSB3b3JraW5nIG9uIGEgc29sdXRpb24gdG8g
bWFuYWdlIGR1cGxpY2F0ZSBzeW1ib2xzLCBlbnN1cmluZyBjb21wYXRpYmlsaXR5DQo+IHdpdGgg
Ym90aCBMVE8gYW5kIGthbGxzeW1zX2xvb2t1cF9uYW1lcy4NCg0KVGhhbmtzLA0KU29uZw0KDQpb
MV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGl2ZS1wYXRjaGluZy8yMDI0MDgwNzIyMDUxMy4z
MTAwNDgzLTEtc29uZ0BrZXJuZWwub3JnL1QvI3UNCg0K

