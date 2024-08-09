Return-Path: <live-patching+bounces-477-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8BB94D4C4
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 18:34:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C195CB2246A
	for <lists+live-patching@lfdr.de>; Fri,  9 Aug 2024 16:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0DE1B969;
	Fri,  9 Aug 2024 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GWpr3JPG"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDBA1BDCF;
	Fri,  9 Aug 2024 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723221224; cv=fail; b=jBZCFlVzIT7q1JtkTCq0DRASIq/A+eAgM+3Qgb2NSBvkPI0uEsehvJfXydJw0iIH9Eqksm0P4J0WFeJ7pi4im1p8KHc2s+iiajykAtlL5AX3d6bTrTDjx92iIAUzKUktuzsMgR3nAAXgOJ8LIE0r70g4sLi0oCwOcvR7/jxxV6U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723221224; c=relaxed/simple;
	bh=bNpJRxGA+7z+FL4+eOvQ7CoYeJDQQHNBVKFBaXE4RHY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FquoLwMMUJbrl0oriyLFulU6tHIroY7feuPLplRva5IWIcswad8bnzoN0vs19iUrqj0Vi/B+nwhUVzxewkXz7sW7jeYkwNxMdJy83gJU6aSxVq/wUbDnHE9XwtMs9W1vzgeh2Q3cKHso+x2UlivfMT/mh1dL8sMyw3P9umo/qg0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GWpr3JPG; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 479E3PNq030186;
	Fri, 9 Aug 2024 09:33:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=bNpJRxGA+7z+FL4+eOvQ7CoYeJDQQHNBVKFBaXE4RHY
	=; b=GWpr3JPGjabbazXp7zPgAB6tEIYWWgrk1eFmH/pOHvocoU0OGFdVqKAHYW6
	DMOv6/KC2qcRvizeX+fWU8L024YRGq0NwxVKUIpSqL9CzlexXkbCRsW2DM/lw9Br
	U/X8vlxCXUCkMTd5uJWSYDFCkjea9+14qDYmpUcMSA756Ih2WmFL5y6HxOGURpNq
	v1PhE2drvoEoB91OTkbJkcwTY6oxNW5CNHE32m6SKpv+e4141l+15NkzyE6Lw9k3
	yLLolPMob2OUfdEfak4QK8TPo8/MBlW9hzy5mNk4ZitgqNhGzJHJOE5+qi3eSg3Q
	OYQSnFIJlhI9MF3dzvvF3DtiS3g==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by m0001303.ppops.net (PPS) with ESMTPS id 40wmhqs4a4-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 09 Aug 2024 09:33:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j4CvrgJODmzaO5/FCESjdOY/CN+vFE1lMixscDbtZ+wa8ivlldNdedGusNGTtWyhXxXISFluoX5DUXehBK/t4LgNl8GIoLE//CNKxHDMNjgpI9OxALO6EatsiteyeSuZYj7xI4feHb/QHlxtcyUD2kiHScb6Wx+1fW83hohhFsgJbB8qWGkOxj8EeUymcroYkIU0sczNoYknqilUGB5kGVbFbeFIXiZJAMwt22NiUzt2ZtVShCHzTKMliyp/5eiaq5pV7xBAqMmZ8N9VLxm6m4Kj+Y8MHQdwTAcpXOvhgM53sikFlGxWNZ3VzN4aSckRCsrWJAXfs1mNKXOeg8RHXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bNpJRxGA+7z+FL4+eOvQ7CoYeJDQQHNBVKFBaXE4RHY=;
 b=ajDUT81p9kepBwsQ4oK2gwsG0tKcFPMiqMrFZAFrGJEYNmERTr9EWd4L4UwWdD4DFBjkG7+DxnoAXdmICFT1rdNjQyD9QDfnXn8Hl5pJzujrsUrtHlg9uAdbd5JmaMaTlnS2CzPutSymdxbzDLCuwLyc5Cz3/wyrHQR6zXuaN5F5NT/ptzm4fV6c0V4Qyfb+MBOwR+OGzbUjS4wG4h+jsursOCjYw7OIosEBlM/7pgLjUI1DK4g/PjizidobVsnUPFzHZdXuJuuTEqMRmnq+bcCce87aWGA1CmAbmPBVLA4bXU9pEG2QZMixvRYKGNm7amcEeAn1K4KFkuOyM13LeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CH0PR15MB6043.namprd15.prod.outlook.com (2603:10b6:610:194::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Fri, 9 Aug
 2024 16:33:37 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.015; Fri, 9 Aug 2024
 16:33:37 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <songliubraving@meta.com>,
        Sami Tolvanen
	<samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven
 Rostedt <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
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
        Matthew Maurer <mmaurer@google.com>,
        "Alessandro Carminati (Red Hat)"
	<alessandro.carminati@gmail.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAFrMgIAAWCcAgADc1ACAAFnCAIABl9sAgAAO7AA=
Date: Fri, 9 Aug 2024 16:33:37 +0000
Message-ID: <5DA1FAE0-1057-4A78-A9A8-CFE10A0C2B19@fb.com>
References: <20240806160049.617500de@gandalf.local.home>
 <20240806160149.48606a0b@gandalf.local.home>
 <6F6AC75C-89F9-45C3-98FF-07AD73C38078@fb.com>
 <20240807090146.88b38c2fbd1cd8db683be22c@kernel.org>
 <BEEE3F89-717B-44A4-8571-68DA69408DA4@fb.com>
 <20240807190809.cd316e7f813400a209aae72a@kernel.org>
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
 <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
 <ZrSW5KgFMjlB1Rn2@pathway.suse.cz>
 <A3701B71-D95F-4E99-A32D-C1604575D40F@fb.com>
 <ZrY4UhJpsFP_vuds@pathway.suse.cz>
In-Reply-To: <ZrY4UhJpsFP_vuds@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|CH0PR15MB6043:EE_
x-ms-office365-filtering-correlation-id: 208b23ef-b1f6-4d90-1e66-08dcb89104cf
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aVl3dHJxbDBJYndtR0x4S0hqeE9qQ1hlZ0ROVXRIc0t3NFlSejJpUC8yalhu?=
 =?utf-8?B?L3FzTGR5OG5LVWYzN2Ewckp4dWZFMDREa2pwbXpIbHZUS0NwUmJVTVJMa3R3?=
 =?utf-8?B?VE5pTkU5V2xKUndHVDRWbS9wZW96RGtiOVphbHhLamJIWHA5bVkzbjE0ZUxH?=
 =?utf-8?B?dWEzeUpMMjR1Rk1IcFg1Rjlzc3hLeTFhTEQ2WDNwSFBNZFhhdGI1R1pSMDBJ?=
 =?utf-8?B?NjBhNVhQdisyWUp5dkxUOTN0ZzhZcEdVZjZPdlk2eFgxU1h4U3dTeFlac2tI?=
 =?utf-8?B?R2dBa1JHbUtRRC91NmY1WGo5L2ZURmtvZGRZRW1iZU9vZkxhd2FBWWQ4aTVZ?=
 =?utf-8?B?REorTDM1WjQ2ME5yeXVONXZmdEdKWnpFa2dMaXFVSjNXb3l3Vm8yc3VYNzRl?=
 =?utf-8?B?cUhsUnQzOVBxMmxiekZVYTU1QzNQRDhHZmVLWnB5djM0OWVBdFlHcHhJd1lH?=
 =?utf-8?B?MU10T09ZRFBrV29DSktFMCtnZTVGWWZxMENKSDhEUjdvRlBkMlUrMHNuV0lp?=
 =?utf-8?B?dnM5MTJrcmZleFNGZ0JaMEdZNnlsVW9mT0w2MjFYUjZ4RmZ0YWlXYTBQMWNZ?=
 =?utf-8?B?dmRXZGtYWnJlMm5pWnVQSXBFKzRvd3ZFUXg4WWY2RjNBK2tZbWQ3TXoyTk1D?=
 =?utf-8?B?ZzhPRzl0OHI1czZ1NkRjZGl3UnpsV3BmR21KUWJqeEtML3B3MGR5Zy9GZkFG?=
 =?utf-8?B?VGt2UEhjMzlVblZyT2g5K1cwRE9hWWpiU2NDY09RNC95WlZ1dGc2ZFZTQVkz?=
 =?utf-8?B?RDhYVHAxYnFhVHA0UmszUlNVa2tqNHhhQ0FYUjZRY1lBMXJXS08xcmNxamp0?=
 =?utf-8?B?K21UQmZWdXRwYXg1aDhBNzJORHB5T2VjTlBoZmU5R01HemVjZmgyaHBxcjRy?=
 =?utf-8?B?TnA0ZDdCTVZtSGt3MG5JNUJEa3FVWUFtOEZ6RGJBdjVOcmZHZ2xNVEt4bHlY?=
 =?utf-8?B?Wnl0eUxDZlJpTE9nbEF4azBRS2lKQ3dYQURNRVI5aUZXRlB5eEZESnV1VHpq?=
 =?utf-8?B?RDlXRzBxcklmWHF0Q3RVYkxmRTJlYUhTeUJIc3NLNFcvTkp4cStmRm5SYkI4?=
 =?utf-8?B?V1BqMy9NaWZ3S2lOaVNXYkluZ0lLOU1LclBBTEt2NG16WXR2ajB0dGdPUUdU?=
 =?utf-8?B?WCthTmcwV1RyZW1LQ1UvVEUrVHJKazNQbmN1RG1la1NmUUtxSldtQ0pqQm5I?=
 =?utf-8?B?SENqclVmSWJpWUhTMW9vN1JJUXVRZHc1aGRWNFVKaVN1VGZ5VmIwSEJPNU8x?=
 =?utf-8?B?Z3YwNmc4YzUzRzUzbXZ1cHRvREtkVkVGOThiaGxWR1NwKzhac1I4NHFNbTUy?=
 =?utf-8?B?MTVGRmpBY0Nzd3ZqTys5Ri84c29ZdHduRHhUUFpzOC9qR2tPYVlKWWs2bHBX?=
 =?utf-8?B?ZU9xOEVjUVd2REprRkhEckJZZFVOa2dWdm1KSGV4ZUtabTB4S2hrY3JjU0pH?=
 =?utf-8?B?NUxkcFFzZkIyaUsyd3RZYWcyY0ZXRkQzSlJ3R3k1N3dsT1FESzFQK3FDQ2lx?=
 =?utf-8?B?Q1hUMU8wZ2NibkxzZUJ3dlBTMEFUWWF1aHByN2FoYjZKa2pOUjlsYmpJNjRk?=
 =?utf-8?B?Z3FKVngyaDZKbGc3SDVxV1NnRTRXbTRTdVJVN09UdWo5bzh5WWNPclNSOEto?=
 =?utf-8?B?Y2Q0MHhOS1RaNjhwT09UUGtXTmp5c2FhbWFmbWVPb3ZBd3FmemRCMDZGbm8w?=
 =?utf-8?B?Y2tNYkJ6TjNrMmJOTHN0ZFEvLzdXbkc1V3poajNQcUdhbCs4NCt6VWhONmNL?=
 =?utf-8?B?MTlBN3BoTXJOemJYa3RQUytFRENsYUhSQ2MyQlNseHRLNjA2R25IMXlFaFRl?=
 =?utf-8?Q?mjZTl0qUWWIZ90vAdLxm/ruRkGKieZCnprEXU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Zkd3S0ZJdEhlNnNtOVlHV2F2bTZBTmRrd2xjWk5NeTE2SlBQNXR4bmFkQ3Zo?=
 =?utf-8?B?dFBNano0VTVKNXJ3eS80RVVJR29JREdCWDFwRlRMYVF4NkZOeXVjcmJKQU5S?=
 =?utf-8?B?d3BPRkY0NW9rSEhCMVZpMVdDeld5SlM0UjNKcEdMK3FkYUNsR3h1MVEvUkov?=
 =?utf-8?B?TkxOVXlxNGxNMDVVTzZiQm1XRTZXUFJmdmgzMjJGTlhvenQwczJOTy9vV3NO?=
 =?utf-8?B?SkJzbFdzN1dDWXJoOFFzcGNaT2ZQWkhFbnpyQ2dZWm1qNHRJY3pkOVlKUS9N?=
 =?utf-8?B?SEJBU0gxVUFreUREak5rZHczbzdRbHJwUVZta3FOUlBLSit0UDhybkt2eEoz?=
 =?utf-8?B?bnFOU2lTWS90eWFpdVpWSlBib0c3SXRidTk4amoyUzdCR2xxODFvQStTK2Y5?=
 =?utf-8?B?Nlk4UURUcTJXY2pDU2E0NUNReWttWXdZRlVyczVsMmVadlFWbUxEbThqVXpv?=
 =?utf-8?B?Q2ZyY0JIanZyWVZLL0xCMVhzZEpFVVk5d1Y2RlVCMGFoNmtDWUdrZUljZU5E?=
 =?utf-8?B?akgvbGE2NGVtejMzRkZ4SkxneDR3cGNtV3pmUHNKNTc1ZFBCTWIwbE5oV3Bo?=
 =?utf-8?B?bGc2Qk85OTBiTVI4a0RXeW0vWjl3TkRENDZxUEhwRFE1aHRkTzQ3SWRCcGhG?=
 =?utf-8?B?RVl3TkJXYWx3a2Y0L3Bjby82dklEU2QzR0ZmQzZhNUtMQ2JLR0VNaWlxMUxO?=
 =?utf-8?B?aUhJanp1c1NKQmd6MHhlMWFrUkZkK1dySkhVOFQ3YlVieHBKTFg1WUVhbWcy?=
 =?utf-8?B?ejg0TmRNcGtzZ2p4cnpINFVIb08yeGFMQktsbk40UVNwN21yT1JlQWhSSGRt?=
 =?utf-8?B?U283TzRsbXNhNmFycTZZL2tISTlFNDlzZmtvTERNbk9JTnZaUEJtUVFDd01H?=
 =?utf-8?B?elFsdWJmdFoyV2VXZFVKNEdZMzRYclpxVzhCZ1pKK1RXZHJSUVJUZk5kc2tP?=
 =?utf-8?B?ODFaS2QvSlg5U2RXQk5NMVlrQzlBTlZscDVwaTdjQVRqY1pRbXRzT1ludWlX?=
 =?utf-8?B?NWdxMFZVMVFmcllDWTFuaUNCY3hHZEVnS2pjNG5udENWUjJ5cTlLMkV2V1BU?=
 =?utf-8?B?VytHdUR2Y3Uva3FtZ2s2d0p6TUExK0F0OFFZS0VhbjVYUmt2dTJPMXQzdHk0?=
 =?utf-8?B?bjAzRy96TFl5eFAyK0x0SElibmVRMHFKTkNlSmMxai9wZ2tIdzJUZUplSitS?=
 =?utf-8?B?QkNUd3ExV2k3R3ZFRFRoVEFLc3dtd1ltZmZzdG5vSlRyaFQ3dVhEcDZvemM5?=
 =?utf-8?B?SjV2RmEzSjVoK2NiMVczY1R3WngzczJyR3hLZU8zemRJaURaWTZXaWVkUE42?=
 =?utf-8?B?UmlldTlabndHdkJxNVBSQ1ZLejdxTFB4YTZ3YXBVVTR4Z0Nzb0tpQVhtOTNH?=
 =?utf-8?B?Z25SdzZDQmVYMDlCYk83OWVoNFRuRjlyeGZkT2xSSVFwbG9GTEZtbmJkdkg1?=
 =?utf-8?B?M3VHa0lkUkZWM0FGMWNROXNLNHI2b1lPUytJWGRFdHZDZzhQa3lSYzBGOUJV?=
 =?utf-8?B?bVg4emRaMTQ4bTFSZ1JOUlZGKzNqQ0tnN1JaRktCQXhIcUNQOS95VjJhZmto?=
 =?utf-8?B?WVE1dnFIaHlmeFlLckhNVkthNU8zQ3ZvSElPZkx6bnJSUUxEd0thUGZDZ0l3?=
 =?utf-8?B?MndZbmtQa3pXY0JEWGRoWEZYdnFQSGh3ajNxd0xJS0MxejI4T3M4Ymo0R3o4?=
 =?utf-8?B?dk5wVHVDTTRrUTNJR0FFT2Z1NklZRkcvbU5GOUNRQ1lmT3Z0b2ZPUkh2dlY5?=
 =?utf-8?B?OWl4Wjk4b3dKNnpXK09sV1l5em5KYUNvbHN5OSt6cVAwRzkycWd5WkVHTnZj?=
 =?utf-8?B?YW5zL2VFa01XQ1lBdTY5QnNhbjZ1M3prTXd3UHFVNHFsWWRrTG55UFhUam5l?=
 =?utf-8?B?ZndBUHNIY1pFTDhSTitYSHluWnJMT1lkU3UzWUMzY0JQK1NPL1BkVER1TXNv?=
 =?utf-8?B?TDNHdWtkclMycG9YYjRvcENSRmxCdUVvRmZnK1VQVW9kSThyZzFNUXdhSmdL?=
 =?utf-8?B?Rk10Z0xlaWQvYTIvRzdmdWJHZ1JqSzQwMmZCQngvTFFkK295cnk4QjVQYmdN?=
 =?utf-8?B?ZmdCS2Jkb09QakkvZjZ6NnF0TDFuQU5rckwvcEYreDI4V29qVUs1a25zcWh4?=
 =?utf-8?B?TlRaOS8vbnZiZGlMM1FSMkZ0UGh5NkU1UjBlbmVTdnNTSDJqNWlkalNPTVkz?=
 =?utf-8?B?aHNrbGRhUGRVMGxZVm9mR0dKcmxJaG9NY0VGamViZmpuQXJ4U0NxR2JiWjlH?=
 =?utf-8?B?MWFBVUp1SjQ3cFNSV2xXWGVucldRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <078F28FDF5A51241B87501D49FAB2228@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 208b23ef-b1f6-4d90-1e66-08dcb89104cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2024 16:33:37.0166
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qdUypq4iz14O+EbQ2stH4W+K3/2dsUMaYt4QJfnO4w3McA5/2+t1KzaJcOTqWslwCTlONO0I6c3ZjZtkXHR1zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR15MB6043
X-Proofpoint-GUID: ymyVHSnwQpP2MeDjipmmu2Ib3xh8FUs1
X-Proofpoint-ORIG-GUID: ymyVHSnwQpP2MeDjipmmu2Ib3xh8FUs1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-09_13,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDksIDIwMjQsIGF0IDg6NDDigK9BTSwgUGV0ciBNbGFkZWsgPHBtbGFkZWtA
c3VzZS5jb20+IHdyb3RlOg0KPiANCj4gT24gVGh1IDIwMjQtMDgtMDggMTU6MjA6MjYsIFNvbmcg
TGl1IHdyb3RlOg0KPj4gDQo+PiANCj4+PiBPbiBBdWcgOCwgMjAyNCwgYXQgMjo1OeKAr0FNLCBQ
ZXRyIE1sYWRlayA8cG1sYWRla0BzdXNlLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gV2VkIDIw
MjQtMDgtMDcgMjA6NDg6NDgsIFNvbmcgTGl1IHdyb3RlOg0KPj4+PiANCj4+Pj4gDQo+Pj4+PiBP
biBBdWcgNywgMjAyNCwgYXQgODozM+KAr0FNLCBTYW1pIFRvbHZhbmVuIDxzYW1pdG9sdmFuZW5A
Z29vZ2xlLmNvbT4gd3JvdGU6DQo+Pj4+PiANCj4+Pj4+IEhpLA0KPj4+Pj4gDQo+Pj4+PiBPbiBX
ZWQsIEF1ZyA3LCAyMDI0IGF0IDM6MDjigK9BTSBNYXNhbWkgSGlyYW1hdHN1IDxtaGlyYW1hdEBr
ZXJuZWwub3JnPiB3cm90ZToNCj4+Pj4+PiANCj4+Pj4+PiBPbiBXZWQsIDcgQXVnIDIwMjQgMDA6
MTk6MjAgKzAwMDANCj4+Pj4+PiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAbWV0YS5jb20+IHdy
b3RlOg0KPj4+Pj4+IA0KPj4+Pj4+PiBEbyB5b3UgbWVhbiB3ZSBkbyBub3Qgd2FudCBwYXRjaCAz
LzMsIGJ1dCB3b3VsZCBsaWtlIHRvIGtlZXAgMS8zIGFuZCBwYXJ0DQo+Pj4+Pj4+IG9mIDIvMyAo
cmVtb3ZlIHRoZSBfd2l0aG91dF9zdWZmaXggQVBJcyk/IElmIHRoaXMgaXMgdGhlIGNhc2UsIHdl
IGFyZQ0KPj4+Pj4+PiB1bmRvaW5nIHRoZSBjaGFuZ2UgYnkgU2FtaSBpbiBbMV0sIGFuZCB0aHVz
IG1heSBicmVhayBzb21lIHRyYWNpbmcgdG9vbHMuDQo+Pj4+Pj4gDQo+Pj4+Pj4gV2hhdCB0cmFj
aW5nIHRvb2xzIG1heSBiZSBicm9rZSBhbmQgd2h5Pw0KPj4+Pj4gDQo+Pj4+PiBUaGlzIHdhcyBh
IGZldyB5ZWFycyBhZ28gd2hlbiB3ZSB3ZXJlIGZpcnN0IGFkZGluZyBMVE8gc3VwcG9ydCwgYnV0
DQo+Pj4+PiB0aGUgdW5leHBlY3RlZCBzdWZmaXhlcyBpbiB0cmFjaW5nIG91dHB1dCBicm9rZSBz
eXN0cmFjZSBpbiBBbmRyb2lkLA0KPj4+Pj4gcHJlc3VtYWJseSBiZWNhdXNlIHRoZSB0b29scyBl
eHBlY3RlZCB0byBmaW5kIHNwZWNpZmljIGZ1bmN0aW9uIG5hbWVzDQo+Pj4+PiB3aXRob3V0IHN1
ZmZpeGVzLiBJJ20gbm90IHN1cmUgaWYgc3lzdHJhY2Ugd291bGQgc3RpbGwgYmUgYSBwcm9ibGVt
DQo+Pj4+PiB0b2RheSwgYnV0IG90aGVyIHRvb2xzIG1pZ2h0IHN0aWxsIG1ha2UgYXNzdW1wdGlv
bnMgYWJvdXQgdGhlIGZ1bmN0aW9uDQo+Pj4+PiBuYW1lIGZvcm1hdC4gQXQgdGhlIHRpbWUsIHdl
IGRlY2lkZWQgdG8gZmlsdGVyIG91dCB0aGUgc3VmZml4ZXMgaW4gYWxsDQo+Pj4+PiB1c2VyIHNw
YWNlIHZpc2libGUgb3V0cHV0IHRvIGF2b2lkIHRoZXNlIGlzc3Vlcy4NCj4+Pj4+IA0KPj4+Pj4+
IEZvciB0aGlzIHN1ZmZpeCBwcm9ibGVtLCBJIHdvdWxkIGxpa2UgdG8gYWRkIGFub3RoZXIgcGF0
Y2ggdG8gYWxsb3cgcHJvYmluZyBvbg0KPj4+Pj4+IHN1ZmZpeGVkIHN5bWJvbHMuIChJdCBzZWVt
cyBzdWZmaXhlZCBzeW1ib2xzIGFyZSBub3QgYXZhaWxhYmxlIGF0IHRoaXMgcG9pbnQpDQo+Pj4+
Pj4gDQo+Pj4+Pj4gVGhlIHByb2JsZW0gaXMgdGhhdCB0aGUgc3VmZml4ZWQgc3ltYm9scyBtYXli
ZSBhICJwYXJ0IiBvZiB0aGUgb3JpZ2luYWwgZnVuY3Rpb24sDQo+Pj4+Pj4gdGh1cyB1c2VyIGhh
cyB0byBjYXJlZnVsbHkgdXNlIGl0Lg0KPj4+Pj4+IA0KPj4+Pj4+PiANCj4+Pj4+Pj4gU2FtaSwg
Y291bGQgeW91IHBsZWFzZSBzaGFyZSB5b3VyIHRob3VnaHRzIG9uIHRoaXM/DQo+Pj4+Pj4gDQo+
Pj4+Pj4gU2FtaSwgSSB3b3VsZCBsaWtlIHRvIGtub3cgd2hhdCBwcm9ibGVtIHlvdSBoYXZlIG9u
IGtwcm9iZXMuDQo+Pj4+PiANCj4+Pj4+IFRoZSByZXBvcnRzIHdlIHJlY2VpdmVkIGJhY2sgdGhl
biB3ZXJlIGFib3V0IHJlZ2lzdGVyaW5nIGtwcm9iZXMgZm9yDQo+Pj4+PiBzdGF0aWMgZnVuY3Rp
b25zLCB3aGljaCBvYnZpb3VzbHkgZmFpbGVkIGlmIHRoZSBjb21waWxlciBhZGRlZCBhDQo+Pj4+
PiBzdWZmaXggdG8gdGhlIGZ1bmN0aW9uIG5hbWUuIFRoaXMgd2FzIG1vcmUgb2YgYSBwcm9ibGVt
IHdpdGggVGhpbkxUTw0KPj4+Pj4gYW5kIENsYW5nIENGSSBhdCB0aGUgdGltZSBiZWNhdXNlIHRo
ZSBjb21waWxlciB1c2VkIHRvIHJlbmFtZSBfYWxsXw0KPj4+Pj4gc3RhdGljIGZ1bmN0aW9ucywg
YnV0IG9uZSBjYW4gb2J2aW91c2x5IHJ1biBpbnRvIHRoZSBzYW1lIGlzc3VlIHdpdGgNCj4+Pj4+
IGp1c3QgTFRPLg0KPj4+PiANCj4+Pj4gSSB0aGluayBuZXdlciBMTFZNL2NsYW5nIG5vIGxvbmdl
ciBhZGQgc3VmZml4ZXMgdG8gYWxsIHN0YXRpYyBmdW5jdGlvbnMNCj4+Pj4gd2l0aCBMVE8gYW5k
IENGSS4gU28gdGhpcyBtYXkgbm90IGJlIGEgcmVhbCBpc3N1ZSBhbnkgbW9yZT8NCj4+Pj4gDQo+
Pj4+IElmIHdlIHN0aWxsIG5lZWQgdG8gYWxsb3cgdHJhY2luZyB3aXRob3V0IHN1ZmZpeCwgSSB0
aGluayB0aGUgYXBwcm9hY2gNCj4+Pj4gaW4gdGhpcyBwYXRjaCBzZXQgaXMgY29ycmVjdCAoc29y
dCBzeW1zIGJhc2VkIG9uIGZ1bGwgbmFtZSwNCj4+PiANCj4+PiBZZXMsIHdlIHNob3VsZCBhbGxv
dyB0byBmaW5kIHRoZSBzeW1ib2xzIHZpYSB0aGUgZnVsbCBuYW1lLCBkZWZpbml0ZWx5Lg0KPj4+
IA0KPj4+PiByZW1vdmUgc3VmZml4ZXMgaW4gc3BlY2lhbCBBUElzIGR1cmluZyBsb29rdXApLg0K
Pj4+IA0KPj4+IEp1c3QgYW4gaWRlYS4gQWx0ZXJuYXRpdmUgc29sdXRpb24gd291bGQgYmUgdG8g
bWFrZSBtYWtlIGFuIGFsaWFzDQo+Pj4gd2l0aG91dCB0aGUgc3VmZml4IHdoZW4gdGhlcmUgaXMg
b25seSBvbmUgc3ltYm9sIHdpdGggdGhlIHNhbWUNCj4+PiBuYW1lLg0KPj4+IA0KPj4+IEl0IHdv
dWxkIGJlIGNvbXBsZW1lbnRhcnkgd2l0aCB0aGUgcGF0Y2ggYWRkaW5nIGFsaWFzZXMgZm9yIHN5
bWJvbHMNCj4+PiB3aXRoIHRoZSBzYW1lIG5hbWUsIHNlZQ0KPj4+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3IvMjAyMzEyMDQyMTQ2MzUuMjkxNjY5MS0xLWFsZXNzYW5kcm8uY2FybWluYXRpQGdt
YWlsLmNvbQ0KPj4gDQo+PiBJIGd1ZXNzIHYzIHBsdXMgdGhpcyB3b3JrIG1heSB3b3JrIHdlbGwg
dG9nZXRoZXIuICANCj4+IA0KPj4+IEkgd291bGQgYWxsb3cgdG8gZmluZCB0aGUgc3ltYm9scyB3
aXRoIGFuZCB3aXRob3V0IHRoZSBzdWZmaXggdXNpbmcNCj4+PiBhIHNpbmdsZSBBUEkuDQo+PiAN
Cj4+IENvdWxkIHlvdSBwbGVhc2UgZGVzY3JpYmUgaG93IHRoaXMgQVBJIHdvdWxkIHdvcms/IEkg
dHJpZWQgc29tZSANCj4+IGlkZWEgaW4gdjEsIGJ1dCBpdCB0dXJuZWQgb3V0IHRvIGJlIHF1aXRl
IGNvbmZ1c2luZy4gU28gSSBkZWNpZGVkIA0KPj4gdG8gbGVhdmUgdGhpcyBsb2dpYyB0byB0aGUg
dXNlcnMgb2Yga2FsbHN5bXMgQVBJcyBpbiB2Mi4NCj4gDQo+IElmIHdlIGNyZWF0ZSBhbiBhbGlh
cyB3aXRob3V0IHRoZSBzdWZmaXggYnV0IG9ubHkgd2hlbiB0aGVyZSBpcyBvbmx5DQo+IG9uZSBz
eW1ib2wgd2l0aCBzdWNoIGEgbmFtZSB0aGVuIHdlIGhhdmUsIGZvciBleGFtcGxlOg0KPiANCj4g
IGtscF9jb21wbGV0ZV90cmFuc2l0aW9uLmx3bi4xMjM0NTYNCj4gIGtscF9jb21wbGV0ZV90cmFu
c2l0aW9uIFthbGlhc10NCj4gDQo+ICBpbml0X29uY2UubHduLjIxMzEyMjENCj4gIGluaXRfb25j
ZS5sd24uMzQ0MzI0Mw0KPiAgaW5pdF9vbmNlLmx3bi40MzI0MzIyDQo+ICBpbml0X29uY2UubHdu
LjUyMTQxMjENCj4gIGluaXRfb25jZS5sd24uMjE1MzEyMQ0KPiAgaW5pdF9vbmNlLmx3bi40MzQy
MzQzDQo+IA0KPiBUaGlzIHdheSwgaXQgd2lsbCBiZSBwb3NzaWJsZSB0byBmaW5kIHRoZSBzdGF0
aWMgc3ltYm9sDQo+ICJrbHBfY29tcGxldGVfdHJhbnNpdGlvbiIgd2l0aG91dCB0aGUgc3VmZml4
IHZpYSB0aGUgYWxpYXMuDQo+IEl0IHdpbGwgaGF2ZSB0aGUgYWxpYXMgYmVjYXVzZSBpdCBoYXMg
YW4gdW5pcXVlIG5hbWUuDQo+IA0KPiBXaGlsZSAiaW5pdF9vbmNlIiBzeW1ib2wgbXVzdCBhbHdh
eXMgYmUgc2VhcmNoZWQgd2l0aCB0aGUgc3VmZml4DQo+IGJlY2F1c2UgaXQgaXMgbm90IHVuaXF1
ZS4NCj4gDQo+IEl0IGxvb2tzIGxpa2UgPjk5JSBvZiBzdGF0aWMgc3ltYm9scyBoYXZlIHVuaXF1
ZSBuYW1lLg0KDQpHb3QgaXQuIFRoZSBpZGVhIGlzIHRvIGdlbmVyYXRlIHRoZSBhbGlhcyBhdCBi
b290IHRpbWUuIEkgdGhpbmsNCnRoaXMgd2lsbCBpbmRlZWQgd29yay4gDQoNCklJVUMsIHYzIG9m
IHRoaXMgc2V0IHdpdGggQWxlc3NhbmRybydzIHdvcmsgKG1heWJlIHdpdGggc29tZSANCnZhcmlh
dGlvbnMpIHNob3VsZCBkbyB0aGlzLiANCg0KDQpUaGFua3MsIA0KU29uZw0KDQo=

