Return-Path: <live-patching+bounces-487-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02E70950F13
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 23:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D4941C2406A
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 21:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 064771AAE0B;
	Tue, 13 Aug 2024 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="c5J1gSYr"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8791A76D3;
	Tue, 13 Aug 2024 21:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723583825; cv=fail; b=sjrEAcrF8gMQCqLe/2Ys8VlMGXOEBf+LAQ9uLTLcTXd7ikBxmTb4SqmJdqY0KKWwNzCUHDdnT+ou0hPzZA6beJ8vHinmnoLAxr7AZqLyR1cuYUtsPI0fjSwnlirM6NlT2kGzmUGS4eCIBLOJryd/fAjCiOs/PdFCP1LzJH+jye0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723583825; c=relaxed/simple;
	bh=eDeZwaBl7pip/wR75W3aQ+R4RuA0KW9JlJML6kC9W80=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tO4Inn2UDt7QRK3Ks8qTzu9Ifnjv+lEKeLoOwYtu5rJu80EHwv0P6tF5oVKzkD/L/z/cVkO4RYeOW9CY86vtwjjwNGZGC2oUezEFndmyb+yR2R+Crjmm2bugKSR6drSs906tNzsWlKIoeFJYoN0NV+LkT8opFFjD52MvQycd3OY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=c5J1gSYr; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 47DLDrQg032573;
	Tue, 13 Aug 2024 14:17:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=eDeZwaBl7pip/wR75W3aQ+R4RuA0KW9JlJML6kC9W80
	=; b=c5J1gSYr2znGapvnJjK0t3bYgU7S5DfnuIe7oaGeM8IDyQueWaj5H4p0r+n
	As7wnC3xMo4APbO4CbXXbc3/OvFPNXgLydz3x+hi7BvKbGd9RIJmv0IFDo44ug+B
	xH6fMI0bIgH6bIW0EWTvZLkiflJGv3nKYiqKHBHhchkY+tpK33sL3IcxOdxcjec5
	KesMcrvvbCjagLbIBZl1OxIRsS9nZRS803BF10X9fFiHV0LIOBQV4Me5Q6BW8aNz
	cf94QdWJdWsbagnE2XkH1Sif/lTrC3Ytpg1nxrRiPZ6HN+0L4t/OGgv8Atljea8D
	qB24WoRDF7s7duPExR18v+4K8UA==
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
	by m0001303.ppops.net (PPS) with ESMTPS id 410e7b8dw3-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 Aug 2024 14:17:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlHbwKh1jXrKSleWtfFUNBmrqZOGK29TGEqLoeYR9PI193G3fEdDTUlO7CGOfAEXgCdHrVvZa7qd+yj8iPtYPOFecS9DiF92xAIOeEMxTHkuU7qP0tSb08iIRIq2/AvFY4G+gvNtQl3rwxDQqUiBb41/gszx/SQLfanDTpFprlUdSuS8J8GK3neo59rBIzuxSZW4DLYUgWB0DPa/0A0+AFandmfWINMWPQtbJ5srAnv1n94TiWvaaclBYp3sTCaRgtGrwhA9KM0O9/uPv2+7e4uHlvH9SDXcJSWULKysemtwhiY37Pgabnh4tA5DumePAPjD4trFYsUFKMzljihVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eDeZwaBl7pip/wR75W3aQ+R4RuA0KW9JlJML6kC9W80=;
 b=ePf2upB5WXFbe2ph5V8GSVoTAQrRT8ly0pAeqddyZ7CN0h79kqqThDQRgi9IrqoBgukgu2vZH5HEzWymGuuX8Y3EcJzWceIxPWgyxIieBNgtOc9jhtGPEyEVBWhpNll0SdXkV/jtAcpQDhg64wMpcusoEKtgsJimvZzfwY/lxr23KY0nHIZ2UEFILqEgkGvXBaenefG2e2K3zIW8Br3ccBsXd+ZMLF9R6Mz66EvhuKSrTEIaFRChiuOdXPijaEagHDEQ0tRrcBa88fysGxFjeVVj8VVPumvVqecr8iCEDtlfo3jq3Wy+iXGc16eoy0mZQGeHDW4O57lILBEGALQZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MW4PR15MB5160.namprd15.prod.outlook.com (2603:10b6:303:187::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.22; Tue, 13 Aug
 2024 21:16:59 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.021; Tue, 13 Aug 2024
 21:16:59 +0000
From: Song Liu <songliubraving@meta.com>
To: Song Liu <song@kernel.org>
CC: "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com"
	<joe.lawrence@redhat.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        "justinstitt@google.com"
	<justinstitt@google.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "thunder.leizhen@huawei.com" <thunder.leizhen@huawei.com>,
        "kees@kernel.org"
	<kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        "mmaurer@google.com"
	<mmaurer@google.com>,
        "samitolvanen@google.com" <samitolvanen@google.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        "rostedt@goodmis.org"
	<rostedt@goodmis.org>
Subject: Re: [PATCH v3 2/2] kallsyms: Match symbols exactly with
 CONFIG_LTO_CLANG
Thread-Topic: [PATCH v3 2/2] kallsyms: Match symbols exactly with
 CONFIG_LTO_CLANG
Thread-Index: AQHa6RYbge/v6zgBfk2EMCJeRPw4TLIlugoA
Date: Tue, 13 Aug 2024 21:16:59 +0000
Message-ID: <7E4D8E14-6FFF-4A40-A29B-4DC48F5DDD28@fb.com>
References: <20240807220513.3100483-1-song@kernel.org>
 <20240807220513.3100483-3-song@kernel.org>
In-Reply-To: <20240807220513.3100483-3-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|MW4PR15MB5160:EE_
x-ms-office365-filtering-correlation-id: c65bcca9-7fb2-4849-f8f1-08dcbbdd4491
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?aCtoU1Q0ZEdNTUZqVFA3cGRwcHFNR0JEVFZkQWtBOXo5UUNrTityNFJGSjdT?=
 =?utf-8?B?cUV3a2RIVkVYMDd1S3VsbHE2R1BoT25UZzBzMDdYVlIreXM5bjV5ZnRaWnBK?=
 =?utf-8?B?L0FYR2dseFBsSExodGhSdytGeFNweDloaS9MeTFGMjRLMEFKMklic1R6enRV?=
 =?utf-8?B?Qi9UY3dudThQZVhtVDd4d2RwYVdBamRaSWFyTmxOMmFPNVI5R1E4eWljTzJ2?=
 =?utf-8?B?eE8ySWJsRDF0NFNBbGZHcXlHdDVBWnVsaGhITjJxVmNSNHpMMThxcndHdG84?=
 =?utf-8?B?ZUs4N2hKYktLb09mQmMvK1NBa0ZtYW5qV1pXenhOQ3lJdEozc1ExNTdHWUdu?=
 =?utf-8?B?V1lHSHkwWUxwZWw0MStWYUJIVTNxam54YmM3dEVsRndGNzZDNVRvR1NZWnAw?=
 =?utf-8?B?MkxRcjMxMHFWRHhLTUxaeHJFVW1tL2VhVy9rL1daTVVzRDBiU1libVlYaXZC?=
 =?utf-8?B?LzRtOVExQ0JYYWVhS0QrY2VQNk1MQ2lNVWZwRWIzNC9yU3A3TGxueDFlS0JX?=
 =?utf-8?B?QmpoQ3lybDY3UVh1ZmlueFdleGdlYnpiQnJUNXJCR0h6aFpkK0JUaHdUbTBp?=
 =?utf-8?B?ejJwMW14a2ZhZitBZ0RtSk1JRVpPY3FEcGQ2MEF4RkQ3M0FRZU1wRFllNWhV?=
 =?utf-8?B?OVdvN3ZGcjkrbmRwc0NCdDh6M2pMekswZzBxc2NsU21nUGRPK0J5WXExYmlp?=
 =?utf-8?B?ZzJWcXBOSFF2UFoyeTZRZ0pnTEYrOGJLWkV6d3YzVEIvNWxwejhQVVZwWGZK?=
 =?utf-8?B?eVpiOG9OVEVIYWlmcUkraEtPZFZGK0JmTE4xL3FPQUdJVzlYeWdDV0E1dnZJ?=
 =?utf-8?B?dHg5cWV2VmZOaE16MzBLZmRnMUVSZVhzSGVyd1dyTURTUDhQR0lTdU5tdDh0?=
 =?utf-8?B?VnN5ZWVMUlRBNm9FTWFXVEVCSnhJS3FPa3VPVkV3ellmTVFZSFArOHE3UHRn?=
 =?utf-8?B?QzVab0NjVVhFWk9wK01KTDZtdWIwaklkWWR4VHBFVmZUZ3UxcFFnOXFzYlF5?=
 =?utf-8?B?RkM4bFFkQ3hsQkVxcTkyTmhWNEVWbTNLSzk2NnI2eG54Uys0YjNJc0tEVWpC?=
 =?utf-8?B?Q3dWbjRJa0x1bXhLdnJ4dUxHNFUrL1BEZ1duOUF4WFRaaDJkQ1FjL2s5YVAx?=
 =?utf-8?B?M3JHZGdsN21TSzd3Vlh4RS9UYWdGYldTM0dUZWQzRnhlSzFJdmZrZGZaVzhW?=
 =?utf-8?B?THl0YTNYKzdUUG5tVFR6T3hpOVAyM3FYcktDcklhOGF0N0ErWGp4cUtZUWdB?=
 =?utf-8?B?N1RqcFVNNVdUS2ZjbXFlSHNIeGkrL3FvUEJyWWhyRjU1b29UR2tYcWVtdnJo?=
 =?utf-8?B?SDY5dEkwNXNvZDhtb1JXdGtFeVI2YktOb1ZCV2owOGhjODF0OWdYak00a3FC?=
 =?utf-8?B?L1RJUllEcFRjWHgwOWdUSUE2V3hlZFRsME0wdXR4V2xraUl3NnRNWWJaaks0?=
 =?utf-8?B?RnVSNFZZWDBESXJSQ1ZuT1pLeWtqanZYRUtPVFJIdUk1aENYaXc0TUpuelda?=
 =?utf-8?B?N05PSFcrRnRXSEtxczdUUDJHN21OSURMYlMyVTVCRFh3TmFnR1h2V05YK3lP?=
 =?utf-8?B?VlF5WWVjRHJ1QUtTWkpjdUZBbjVWVWhrZDFpN0lGMnBXaUVNWE0vS2tyRWpv?=
 =?utf-8?B?SGVHZFBDcWFaT3N6K3VlWFZJTFpNZEV2VU44THE5aU1qbHgrSlFVbUY0eDBU?=
 =?utf-8?B?azNaSnk0TUxaeHliVngrQUJFQk8vNFdnYXk4NmxmU3NGdWJDMDBVc1kraXI1?=
 =?utf-8?B?TmV1bFREYVhOQlU4bk4yVHF0ZGJIOWJmWUVhR015OGNXNzlYYXpScVBoQnAy?=
 =?utf-8?B?M21MKzVoT0JSbW5GUlZYWDR5SlJFdDQwamZYTWNwN1NONlZ6SjY0bUNtTlcw?=
 =?utf-8?B?eFNKUVp6WWM5MHRHSk9DMFVnV1BEL3gyMUI4NDdKSnpmRmc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RFcwMWZhUCtuMVpnZnYzR21jUWRRY3pUZmxybUptS0lWL0JkWXl6WURMYTRU?=
 =?utf-8?B?Ri9WUVdZYkF1VzJvYzl2OE9yNll5WGdNMHd3ZVN4Z00rVExHckp5V0FSek9x?=
 =?utf-8?B?NFA2VHpyVElHbEx6Q2lhY094SlB4QXFoaytya0dXc3VkUk4yblBBYm5reHlY?=
 =?utf-8?B?Q25KbGZmYk00a3JIUXdxQ2trdWJhYzF4K3Uwbi9SVDJXQ0crMEpGYlZSV2Jk?=
 =?utf-8?B?empScTVUS3B3Snc3ekNnUEgvNWtmMGNyaSt0Q1RTbmRIQUFJN1AzUDhkTHA3?=
 =?utf-8?B?UjNGcXZLamVDNUpwYWU2T09VTzhYN2UyQjFoWnNmTGNzUVNRYklJVEZZaHJk?=
 =?utf-8?B?MHVGOUdwaDV4M2M5V0NLaVZUS25MVHppVE1hdC9hcTB0Q2dYNVhRTkh6Mi9T?=
 =?utf-8?B?KzBRcjhmVitMRy82Q1pxWDkyUmtpbFF1Y01nQUFWSHR6K1M1eCs0RjZMeTJO?=
 =?utf-8?B?R2dWREZpdUNqc09lZVBhWWgyNSs3K3pxSXFQVUNUTUo2V082a0JETXBMbmE4?=
 =?utf-8?B?QWVxSHVFVVFCbDZOejdJWWxwN3VDaG5tY0Y2ZTNkV0R5ZFJkRnpIMnRzR0p0?=
 =?utf-8?B?RFVQSzhidktQUzM2WEFrY1VMYk1sc25UZlpLa1J3QXAvRWtxWGMzVkU1V0cy?=
 =?utf-8?B?RjUxQVRxcjYvSTYyWDZLU3lCUmRIbGlXQzJSL1lYc0xMbURpTmoyb01TUXlx?=
 =?utf-8?B?OGYzNjhrdDRrVkVIcS9veWIvRVpTU1BERitWS0k3cU1YM1FJTlNnMkhncG1x?=
 =?utf-8?B?bDFqS09tLzkxWmhDSFl5SjAyVjllc3l2YlNVdzVBSk8xNWZ3K08vbHB3c2tl?=
 =?utf-8?B?RUJiY1N6cWluRHZFZDRjaW81eGlqb2Y2VGJHeHNPZnY5U0pZcWU0dHNtajN3?=
 =?utf-8?B?L0dQVjRBdC9LL3NCY1hmSUhXLy9SWU1PMnVOZmtNeGhZMXlqYmp5b0M1TFp1?=
 =?utf-8?B?SWgzdzlETDJRMG9hOWt0R3RkenBWN1ZqdVlVSlFjOUlRbDUxZ1gvaGdIRDNk?=
 =?utf-8?B?dFRhK21FLzJhR2RYTWdDbm5jYjA3QkVXRVZYV3cvUGIrdlFDbFJvNENOTi96?=
 =?utf-8?B?aDVkRzB5NHIrbUpzS0hzSm9wNTRoZkx2RXBOVU1teWZ2TzJkUWh2S1MyNUFI?=
 =?utf-8?B?dUZueXJDSkI1MXgzZUQ3cUp2cmdqOXMvL2tYaEJoeGFzZVJ6MDlvZ3hvMlZa?=
 =?utf-8?B?bllGS0ZsZlpoZmxCQXIyQ3BCU2lNVU1lRDN4K0VJT25GNjF4K0xMOW9GSGtp?=
 =?utf-8?B?QjRiNVRvMFdEdTFtMktIU1UwT2pKay9ZbUp1QTdlRDhLVDQ1UW5HWURsYjRo?=
 =?utf-8?B?bElBNzZ2MTFPV2xROFBucjlETHhOeXJFQ3hkVGQ3VDBaVy82b0JLaVhaTTRy?=
 =?utf-8?B?MkVOVklsUnpQWGlZYkc5NzRiVWkvYS9vcFJmMVk4YWwvT01BZnd3WTlHK0Q3?=
 =?utf-8?B?Nmpsc2xDZGtSdGUzSStkRGNQZUhsLzczTFRpTDBqdzhsM1RzOTFNMzVIL1gw?=
 =?utf-8?B?Y3ZlZUdpN0FxWC9FL0MxdTFGT2pkWThOWHBacXF0OWlqVHVQNWk1Q2ZnNWNq?=
 =?utf-8?B?czlCRmRjdlhGWFNrd2dxNEZ0VkdlcE1oa0ZWcWJudXF5c3d0K3VpemY1YmNV?=
 =?utf-8?B?RjBObzVpS0twK0lJMFpPQXBmZEFVVS8rallNREZDNWd0WWR2NjhjN29kMW5Q?=
 =?utf-8?B?SmgvS3Nxa0xXU0U3clM5YzdwQk02Z1V0ZmkyalhNMHVzNkJWS09QTEx2REt1?=
 =?utf-8?B?cDZGTW1CSVJRM1VTZFo1SWZxallreXMvRmsycUd2N2RSUWg4c1VxUm9xUDdr?=
 =?utf-8?B?dFNJQVIyVHEyM1NYbm83eVRidUNqdjRsd1lRNEpMZGtkbzBSdUxVK3RHMTQy?=
 =?utf-8?B?dzBSNzhaN3dTTWgxTzBjUFl4Ulo3d3Z1U1VOYjF5aTVtTktaM25PYXUvWkNn?=
 =?utf-8?B?TGNkczYraElpSHVFVnF6THhCV2x1MnJtTDdhMWF1Z3BHdVFOSjVhTHdqUVE0?=
 =?utf-8?B?SGZHUUorNGk2dkpaVXQwRWcrYmlsSEZlajREOC9ub2lHL2syR0hMMEJ0NFhG?=
 =?utf-8?B?RWU2bVkvVUV0bXBrOU5KWVhSMXl0Z052WWxTVUNCTEp3ZEtKMkFPWUdEUlBk?=
 =?utf-8?B?RklVc0tUTGlQcGdKdTQ5dkFwaXBIZTBQeVFUZjFja2NoOWJ5cFBUQ25EVFQv?=
 =?utf-8?Q?U7jstiyW7RVuZa9kmQTxNAs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D0D1E0785CF60449A81FCA24408338DF@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c65bcca9-7fb2-4849-f8f1-08dcbbdd4491
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 21:16:59.2018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvrDWQqMz1eaL83kIZ2xjwAe6g+7jYNoOA6BlSjBOmlbSNqQjcug2449+Ewn1UMN3LGDBlj/rkgk0eh8PCnGxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB5160
X-Proofpoint-ORIG-GUID: 3fgiyG1UNih2sBZT7rNmYMifXR7vLXUG
X-Proofpoint-GUID: 3fgiyG1UNih2sBZT7rNmYMifXR7vLXUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-13_12,2024-08-13_02,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDM6MDXigK9QTSwgU29uZyBMaXUgPHNvbmdAa2VybmVs
Lm9yZz4gd3JvdGU6DQo+IA0KPiBXaXRoIENPTkZJR19MVE9fQ0xBTkc9eSwgdGhlIGNvbXBpbGVy
IG1heSBhZGQgLmxsdm0uPGhhc2g+IHN1ZmZpeCB0bw0KPiBmdW5jdGlvbiBuYW1lcyB0byBhdm9p
ZCBkdXBsaWNhdGlvbi4gQVBJcyBsaWtlIGthbGxzeW1zX2xvb2t1cF9uYW1lKCkNCj4gYW5kIGth
bGxzeW1zX29uX2VhY2hfbWF0Y2hfc3ltYm9sKCkgdHJpZXMgdG8gbWF0Y2ggdGhlc2Ugc3ltYm9s
IG5hbWVzDQo+IHdpdGhvdXQgdGhlIC5sbHZtLjxoYXNoPiBzdWZmaXgsIGUuZy4sIG1hdGNoICJj
X3N0b3AiIHdpdGggc3ltYm9sDQo+IGNfc3RvcC5sbHZtLjE3MTMyNjc0MDk1NDMxMjc1ODUyLiBU
aGlzIHR1cm5lZCBvdXQgdG8gYmUgcHJvYmxlbWF0aWMNCj4gZm9yIHVzZSBjYXNlcyB0aGF0IHJl
cXVpcmUgZXhhY3QgbWF0Y2gsIGZvciBleGFtcGxlLCBsaXZlcGF0Y2guDQo+IA0KPiBGaXggdGhp
cyBieSBtYWtpbmcgdGhlIEFQSXMgdG8gbWF0Y2ggc3ltYm9scyBleGFjdGx5Lg0KPiANCj4gQWxz
byBjbGVhbnVwIGthbGxzeW1zX3NlbGZ0ZXN0cyBhY2NvcmRpbmdseS4NCj4gDQo+IFNpZ25lZC1v
ZmYtYnk6IFNvbmcgTGl1IDxzb25nQGtlcm5lbC5vcmc+DQoNCkZpeGVzOiA4Y2MzMmE5YmJmMjkg
KCJrYWxsc3ltczogc3RyaXAgTFRPLW9ubHkgc3VmZml4ZXMgZnJvbSBwcm9tb3RlZCBnbG9iYWwg
ZnVuY3Rpb25zIikNCg0K

