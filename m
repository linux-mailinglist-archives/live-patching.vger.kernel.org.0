Return-Path: <live-patching+bounces-456-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4234C94B18E
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:44:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 654A11C20B94
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 20:44:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B977D145FEE;
	Wed,  7 Aug 2024 20:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GZsvqubX"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0646D13D265;
	Wed,  7 Aug 2024 20:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063437; cv=fail; b=ibEs3b/jMi62KbuJ8zZKY+CBmUxIQV67oIUH8yobYv92EvqPYJJ2uTZU3mSE58U/UMicDvSn1d7AZWLWWVv9ASQuf7kVhI4Ty43S4cTKNEDBTEgfIyb4O8ANyd47IxBdTu8WKGund5DwWorxH2WDnKSc0jrDqOCkqdIrqbTu+AI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063437; c=relaxed/simple;
	bh=A66zvL5YD9zw3dUlAF3NE72XTDR9UCCktFp+HwRpr80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mpnZAUPpmPwUqCwFoVIcn+KUeNZUl2AQ7QhdokLGbvtzoBzRRLFk62aUoenhrcAxrxtBOuLP+Cyh/RXuIw1W7QzFjUTTVXHSJ1v6SBHc/x1AQawW6HsU98HwmrtlBIfDXiR8bYl0QnVisgaOhv1QV7kCdU70VBx1RtU/mrqCyjo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GZsvqubX; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477JKHTH013805;
	Wed, 7 Aug 2024 13:43:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=A66zvL5YD9zw3dUlAF3NE72XTDR9UCCktFp+HwRpr80
	=; b=GZsvqubXJIPIb3DYFSh8GDZ6HD3zjqn9NURFB3lHNpGgpSElzgr/YGg+N25
	uqE80HmduCgB2yzH0ovm1mTSeLUXDu85ZkPmXXEYfuJmnoJCLqR3BODT01HKeLog
	eK/ZkUN3MbXxuCzqfM1He+ZgifkeHSwHZRJXa3f9+YbA3zaLrGk2ovfKE4TASOIn
	/lIFnhB5+jT3AX5czhr5V1isoq8Q3MI5crYLIj7ry5Jdl/EnO+DKpbrGAbCCVCmJ
	9HF/bJj4Bsh76B/CtB/1ykCV6tjW8w/7qHG9+DDnPF4SgQx+K/crIRoWyfDzsWrC
	+uEz8lSkTBddFQIRt96oKRB44AA==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40vbk9a9gx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 13:43:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qKO7IITSqtBcqXBc9mw9E4JSdT1CFvHo1LVD/vJiIcH5gAxUaz84NDLTPkg/8jjjZDb5Md/TT2kGa4lerNslfJ6qXzyH3JWyJi0aG/HJWOszxIeFaUVQCWYy0eAuh1CchS597LKbcPMvK2yibxvMg6M3Ij0ehjQNc3gobEJlVh89/gFMBNERWyZlgJsUYM7s9n5l4zK4p9G7506uPVMQXdYIrCq3HYBT8IlGNeaHJjNMoH0ND58BX7NJiRJppFULjh6GPA3GuUtjRzx9qEjyX9D/q1D9ah5D6e+aJVHeO1Qr+1l3LKICfNqjUYW8J0AWEUwB25dxculrJ7ZYr3ET5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A66zvL5YD9zw3dUlAF3NE72XTDR9UCCktFp+HwRpr80=;
 b=KtD+RK1cczeY4Qv9bNinwAbJqFAxVjuumpJSfM7DECG10wWgEaWfrk5ZYhcPPtKwcJbP+lT+VIhgFzfvLFcH97lTauPTphFvZiz6R/ef2aS8osQuK9ffmMuyUqX8SI9Eodi3Y2gCCZWTM9ZzIyRiDBbxoQPu+dK8S8tjHTl6JDdnadcuJuS1hlRcmOnxOQ6jiZuRQMcZKtRT8ERcJfEMZPy3pnv8smJbdt1ajWFl+xrAIt+EybGYcvUv5diSioO2V+y1omy7BfiqoobtrLTx/ymP1ccUuVcM5eRr9uF9HRtiD2bac/yLnWCOTAR/qt+h0NWB745D0pys4F4w93ZkHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4404.namprd15.prod.outlook.com (2603:10b6:806:193::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 7 Aug
 2024 20:43:51 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 20:43:51 +0000
From: Song Liu <songliubraving@meta.com>
To: Song Liu <songliubraving@meta.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu
	<mhiramat@kernel.org>, Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek
	<pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Nathan Chancellor
	<nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt
	<justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen
	<thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel
 Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Sami
 Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAKAOAIAAB6oAgAAI7ACAAADtgA==
Date: Wed, 7 Aug 2024 20:43:51 +0000
Message-ID: <EC313E72-2E6A-4114-A8A6-86093B1E962A@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-4-song@kernel.org>
 <20240806144426.00ed349f@gandalf.local.home>
 <B53E6C7F-7FC4-4B4B-9F06-8D7F37B8E0EB@fb.com>
 <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <2622EED3-19EF-4F3B-8681-B4EB19370436@fb.com>
 <20240807160826.269f27f8@gandalf.local.home>
 <A17155F6-1B57-4B25-BAB5-C03A59BBB8E3@fb.com>
In-Reply-To: <A17155F6-1B57-4B25-BAB5-C03A59BBB8E3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB4404:EE_
x-ms-office365-filtering-correlation-id: 04fa1641-2043-4c7b-ef27-08dcb721a57e
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?SThqOWZWRWFaY05CTXRidDRXM0dneXlvYTZCbHBKc2VYdTlONnhQaUJFNFow?=
 =?utf-8?B?WmFoQzJ5d1NKOWVaSk9manhoNXY5MmdKMUZYamFLc2ptN3ZLenZJaUZjNEE0?=
 =?utf-8?B?dk1IUzRqa1R6MG9XdnAvSjREWENmd01DcmpkVzFreVp5SEFoSER1amlWMlhn?=
 =?utf-8?B?VTRnREFQOENPRUN3ZVc3ZE5BMzN2QXZnOGY1SE5kczlVU2k4bnpGZEoxVHc4?=
 =?utf-8?B?cTFlNUY3UUNTQWNrQm1TeUZBTWNoS0dncmRyTkxPZ29kVDhLQk1NS0Q4ZXMy?=
 =?utf-8?B?OTBOMklCdHJBNWtNeURuUUROeWI2MlJPOGhEWXRMNjd2ZTJRUUhWb04vb2h1?=
 =?utf-8?B?c1lMNG1WeDJ6d1hWcW5LbUwzTjNYVkZvd1IzTkN6VVhZRnVVb05TQnBSc1Jt?=
 =?utf-8?B?TVJyRzQ3ejdKbENFTEFURG03amlFZG1mWDlmSEZNRXB1b3RhSy9sbERBV3dT?=
 =?utf-8?B?aFpNQlJ4Z0pxQlBySTY4TEVYeVROaHE0K21mYm9EMXlQQ3ViL2xlTStvTU9O?=
 =?utf-8?B?ODBWOVVsNHVuaHJBZ0FuMU0zMXpQZzRGWXVzMFB4QVZSNTBXRG5Jam1MZ0tC?=
 =?utf-8?B?cTZnYmFWa0pXYTlSVzNYQm1EdkhLYUticFFPS1FqaTlCQjBac2VZM0UyMjQ4?=
 =?utf-8?B?c1BXa0pkdEM2UWx0WE1aaG9XTHp0Q1RGaVJ0eXRnTDFLTGpIbjBuUG1ucEQ1?=
 =?utf-8?B?emkvMDRsbGtSR0xSYXZKY2piQmI1OE5jOGRnQTVKMldzU1NTNU11dUphZ1Y0?=
 =?utf-8?B?SVEzeGYrRDdlNDVjRkR4cVZHWEtJU2EvejlQOWhma0NjQ2kyQkk4QkNIWWk0?=
 =?utf-8?B?M0hpUHFvYk5wcXlEWnFMQW1OazZvb0I5Z2tyeVl0TVgxWG5VSlJvZ2RTR0My?=
 =?utf-8?B?NGJFVk45M0FONzNqVWZiSTI5MzJBTkVWeFY0TEhhYUh4d3FzVEllUUVkd3lL?=
 =?utf-8?B?cjhySG1Vcmx2S1JtbHNpTTNjZUg4dWEwbUVMdUpHUjYwNkt4LzZJYU9uNlJ3?=
 =?utf-8?B?UXVrZ1RiYTl6b1VpZjNJVFo1SVozUmw4NUVaQW5VSE9OZlhrYUxjTFVldFFa?=
 =?utf-8?B?UFJyNENCY1ZyMmNWV2I2ZmpSNXFjTUE4WlU1VnNlSmhjVTVCSkt0Qk44ZHJs?=
 =?utf-8?B?WW8rdEtnWm9xU01JeStaa1htMXBIdVI2endhMllKd2J2M25tdE52NUduTEpl?=
 =?utf-8?B?TTQzYkdUK2M5cEo3QXJXd01aMUw2S2t1Y3kvNjBaL3JPbDB6Q3phZWNEYVJk?=
 =?utf-8?B?S1pncngzTVVVUlZGSUd0QzBWV1hSelpkc2FuOTZSRmtwZ2tLcTlCUG1wQjVC?=
 =?utf-8?B?b0ExdjlNeHBhS0JaazNCdlNvWXBNNGVOSU1TcGo4STVubGZqRUZhZktnUXdZ?=
 =?utf-8?B?bUx3dllxWTRRbmxuRHRuR0JLWGFpdStrSVg2TkY4YjBNNlM4U2w5c3Bwb2tO?=
 =?utf-8?B?THNqRzEvTTcvWEVNbWZzTjE1RmRPdnk4Y1RvZm9EbWxLUDFVNGgzNzJDQnV2?=
 =?utf-8?B?SDRnaGlzaHhMUWcwbFBzb3F2cThNRE1qMGk2ZDF6RVA0QXVacENjQkFNM1cx?=
 =?utf-8?B?ODBPYmhOQlZjT0wveG9FYUh3WG90cDhFNjdDbG8zTStGOFBGTUFwWm51YjRm?=
 =?utf-8?B?cSszdGd5aUlnQmd5eU1RMlBOeXZBZXdNbmVsMnJObGI5Qm5SL3R2eFhjNkQ4?=
 =?utf-8?B?WXBGOXhQOWQ0U3ZUTW1jaFU4Q0QrUFlSWHc1Z0pONVp0SDRWZUNvOUlWYWoy?=
 =?utf-8?B?ZWphZ2RCSVBtTTNlSHoyT2xvTUY3MXFvdnJrOVZrS1I3UEEwbWdlV1N2QURP?=
 =?utf-8?B?SlpCbnhXR3NPSzBFMjZhaVFoTkNQem5OdmZsOExqbXNTZ01wd1J3UUVXc2xj?=
 =?utf-8?B?Y2VGMmk0VHJSTVZiZ0xBNDMrdk9SMVhHUDNUcm5OeHJFWWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?U2wxN2srV1dVMnpWL0JnQ1IxeXRZMEtsNFJsbFkvU2MvUU9wS05zVkdDSUpK?=
 =?utf-8?B?Y3QvNVdjQUcxQjgxc1dGbXVCcnJPcEZ5UzMwWTFHZk5jU1dmUkxzeGt4Qkx3?=
 =?utf-8?B?S0VvTVVLTnV6TnRCMTloN0lENEhJWWM3bldnTHVDdTBsNmh5UlNmVThjM3kw?=
 =?utf-8?B?VDk0aHlTbWRwb2puTUV1M3EyR0cwbmhocmpmc3JlblVOL0M3ZXFIMXJCOW42?=
 =?utf-8?B?L25KbWZ6TUZBNkNLYUJsRVRRVzQ3aEh4ZEhCUjMrVG1mTGNQeW05ZzZhT2Rh?=
 =?utf-8?B?MFZ2L1U5N0t5dW8vSEgybzdYdjZBazRNSGFQNnkvVXhQUkpoMDJ1TXhGYk85?=
 =?utf-8?B?dkdiK25xSUtKUU9zRVg3a2JhRmtybGh4YmU0ZWRNUUg3dHd3aGxGWjlTVjc4?=
 =?utf-8?B?ekkwanFZbFlHa085YU8xOCtQbnNVZWZJdTR6WWZRNWdGUEpjdzM0dkhxUFZJ?=
 =?utf-8?B?WVcycjMvT1FVTUpGR2hpd1NNWk0zd044TzNCMXdONDg4b2hsNkxiZWRJeGth?=
 =?utf-8?B?WGRQRDBpeFZVYlI1U1hhcFBvbEZNS3JWTHBUc1h3NXRNZ1FZMnd4YVhackZK?=
 =?utf-8?B?c3M3SGFGazhGb3liL1FHK2NIQ1FiblptL2xJT0NRMUlweExNc1QyQ1kvb3Rl?=
 =?utf-8?B?dDZKZ1ZpVytaMHA5LzRiZmlFL0Q2WkEyUEtYdjFBQ2JIdzNtMTIwOWM1UnlJ?=
 =?utf-8?B?d2w1bE1MUmxudU5VVE5VaW5PZC9mVy9Bd2RBRVF6MWtpdDJNdmJlTjhWbjNK?=
 =?utf-8?B?NkF2dTF3Q3A5cFltbGpnSGpoVW44M0RIY0RFT2lQQW9aOExjWlZLYTFTenA5?=
 =?utf-8?B?aVVZQm9HaytLa2IyNHcweWNrVGFQaTdPRkpZTGMrUmtzelJhNHMyNlExS0dG?=
 =?utf-8?B?eFdFSzVMVzMyWml1UHlLWlAzbmRVOUlZL1lNMkRicGIzRkV3QlMrblJncjhh?=
 =?utf-8?B?RU56NVo1TTZFdGVlbFU3bGVvWnpMZDRwVWxhWnZXNDlMTEVpTjhxdUtQSG5u?=
 =?utf-8?B?QmhiMjFYSDRUd2JnL0JDcEVQdFBudWd4c216b293cTJKamFnRDcwQ3FnMDBv?=
 =?utf-8?B?bWJXSGFxVkNqOWhJeXJjdmM2dVVoeFlNckJxRzRUSk9hdzBtdWR2bm5DdTAr?=
 =?utf-8?B?dm1CNGN0bGMxdGlBT3d4eitVMFRyK0JGZytSSlEwNzRhSHFlbVY0TFp5R2l6?=
 =?utf-8?B?SkthSDFzZUVMSGxQM1hBUU9QQ1pOK2RIc0U5NVp5OFFEQktIV0sxaTd3T0FK?=
 =?utf-8?B?ZFlHSkN1OGdYRmlVa1BYb0ZvWG1YNVJod0JxV1B5ZW10SnBVSUk3czM5V3Br?=
 =?utf-8?B?ZU9MS0dLeG1BNVZDQ1hvbjRiMkhJVWNHZVlaKzFQN3VDQ0tFdVo3aWJiQlp5?=
 =?utf-8?B?M080Y25SbEFVSjlRN2xVSjUyQ3NRRnYrRjJBK0svbDhMazZVcUg1Ry9NY1pj?=
 =?utf-8?B?WGlRQkZ3Z0x6NGJ5MHpPSk9GRHJNVHBubGo0RHVMUU9KczZUZjlQc0xHcGR6?=
 =?utf-8?B?YkJyOXpsQk5uaHRmK1k1RUhtTHlNVnROdnlHTS9obHp2MFIvTnpCUkFSNkhB?=
 =?utf-8?B?SG9YTE5GdU00NHdXR3dBRHlzOGZVQTdUQmlTY3B1TGZtTEVVbVlKMFh4Qm5N?=
 =?utf-8?B?bXVyc1JDMTRWRUVabGVUU2F2Skw3TEJSMXdwVHJlVldqYUtWV2dER0RYTVds?=
 =?utf-8?B?Mjl0ZTRwTmNvMGZxUFJqS2FVMHBRb0Y5R1cxMnlWQklxZTRPWUwxT2t3R1Bz?=
 =?utf-8?B?M1QzeFJHdEgwSnJjb2JwOUx4bWs4aU0vUjBPdmhqdTIxY1g0K2VRU3I1ajBP?=
 =?utf-8?B?Mk9NZFBmSGFodGprZEd0UDNMSEk1ZHpyblFCUUl5ekZZMlJDckRNbmVmdnI0?=
 =?utf-8?B?NUMxSUxGWUlDSVBQNzErak1JWXBlcDV0cWVxaENyRmd4OFM1NlVLdGowTk1s?=
 =?utf-8?B?bzNrZ2ZsNUI3NG5LOGZJdVdZOVBVRGlyUXJ2YndXM0hrZzYzSkVKS1VkZW5r?=
 =?utf-8?B?RXY0WnY3Q085MVc2SWRWUTJUS2FGMElGTlhKeXhGbjBBbU9jNEZXYmQyZ1Np?=
 =?utf-8?B?TndaYm5XMlVUMzQrRWVReWFkL0tYcEdUMnR6R3lMWUZTeFdSb2ZZc1EzNTZq?=
 =?utf-8?B?Qy9YTmVwTXBLTTRMTSsvQk5oQ1hkaHM1dzJ5SU5rSHdaYjVKNjFiVlpZVnNZ?=
 =?utf-8?Q?yH9b8R11bjD+fXQJPDP8+84=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D9282F7D00F6254C8726B7ECC7633CF6@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 04fa1641-2043-4c7b-ef27-08dcb721a57e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 20:43:51.7756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xEseXmqR+kdSfjGCq/L6zsAodjJzlnSjYyOqNR8H8TltBrO7kJIkGJEcVIaaLkEyY6Niw0A7tJ8X9pJMo2nRvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4404
X-Proofpoint-GUID: CPJmhmz1lI2g_e2EfooA6Eb-IgZiLaQH
X-Proofpoint-ORIG-GUID: CPJmhmz1lI2g_e2EfooA6Eb-IgZiLaQH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDE6NDDigK9QTSwgU29uZyBMaXUgPHNvbmdsaXVicmF2
aW5nQG1ldGEuY29tPiB3cm90ZToNCj4gDQo+IA0KPiANCj4+IE9uIEF1ZyA3LCAyMDI0LCBhdCAx
OjA44oCvUE0sIFN0ZXZlbiBSb3N0ZWR0IDxyb3N0ZWR0QGdvb2RtaXMub3JnPiB3cm90ZToNCj4+
IA0KPj4gT24gV2VkLCA3IEF1ZyAyMDI0IDE5OjQxOjExICswMDAwDQo+PiBTb25nIExpdSA8c29u
Z2xpdWJyYXZpbmdAbWV0YS5jb20+IHdyb3RlOg0KPj4gDQo+PiANCj4+PiBJdCBhcHBlYXJzIHRo
ZXJlIGFyZSBtdWx0aXBsZSBBUElzIHRoYXQgbWF5IG5lZWQgY2hhbmdlLiBGb3IgZXhhbXBsZSwg
b24gZ2NjDQo+Pj4gYnVpbHQga2VybmVsLCAvc3lzL2tlcm5lbC90cmFjaW5nL2F2YWlsYWJsZV9m
aWx0ZXJfZnVuY3Rpb25zIGRvZXMgbm90IHNob3cgDQo+Pj4gdGhlIHN1ZmZpeDogDQo+Pj4gDQo+
Pj4gW3Jvb3RAKG5vbmUpXSMgZ3JlcCBjbW9zX2lycV9lbmFibGUgL3Byb2Mva2FsbHN5bXMNCj4+
PiBmZmZmZmZmZjgxZGI1NDcwIHQgX19wZnhfY21vc19pcnFfZW5hYmxlLmNvbnN0cHJvcC4wDQo+
Pj4gZmZmZmZmZmY4MWRiNTQ4MCB0IGNtb3NfaXJxX2VuYWJsZS5jb25zdHByb3AuMA0KPj4+IGZm
ZmZmZmZmODIyZGVjNmUgdCBjbW9zX2lycV9lbmFibGUuY29uc3Rwcm9wLjAuY29sZA0KPj4+IA0K
Pj4+IFtyb290QChub25lKV0jIGdyZXAgY21vc19pcnFfZW5hYmxlIC9zeXMva2VybmVsL3RyYWNp
bmcvYXZhaWxhYmxlX2ZpbHRlcl9mdW5jdGlvbnMNCj4+PiBjbW9zX2lycV9lbmFibGUNCj4+IA0K
Pj4gU3RyYW5nZSwgSSBkb24ndCBzZWUgdGhhdDoNCj4+IA0KPj4gfiMgZ3JlcCBjbW9zX2lycV9l
bmFibGUgL3Byb2Mva2FsbHN5bXMgDQo+PiBmZmZmZmZmZjhmNGIyNTAwIHQgX19wZnhfY21vc19p
cnFfZW5hYmxlLmNvbnN0cHJvcC4wDQo+PiBmZmZmZmZmZjhmNGIyNTEwIHQgY21vc19pcnFfZW5h
YmxlLmNvbnN0cHJvcC4wDQo+PiANCj4+IH4jIGdyZXAgY21vc19pcnFfZW5hYmxlIC9zeXMva2Vy
bmVsL3RyYWNpbmcvYXZhaWxhYmxlX2ZpbHRlcl9mdW5jdGlvbnMNCj4+IGNtb3NfaXJxX2VuYWJs
ZS5jb25zdHByb3AuMA0KPiANCj4gQWgsIHRoaXMgaXMgY2F1c2VkIGJ5IG15IGNoYW5nZS4gTGV0
IG1lIGZpeCB0aGF0IGluIHRoZSBuZXh0IHZlcnNpb24uDQoNClBTOiBDdXJyZW50IGNvZGUgc3Rp
bGwgcmVtb3ZlIC5sbHZtLjxoYXNoPiBzdWZmaXggZnJvbSBhdmFpbGFibGVfZmlsdGVyX2Z1bmN0
aW9ucy4gDQoNCkkgd2lsbCBjaGFuZ2Uga2FsbHN5bXNfbG9va3VwX2J1aWxkaWQoKSB0byBub3Qg
ZG8gdGhlIGNsZWFudXAuIA0KDQpUaGFua3MsDQpTb25nDQoNCg==

