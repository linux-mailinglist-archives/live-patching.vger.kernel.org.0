Return-Path: <live-patching+bounces-385-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6716592C1E5
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 19:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A5A51C235E1
	for <lists+live-patching@lfdr.de>; Tue,  9 Jul 2024 17:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9281A1A08D0;
	Tue,  9 Jul 2024 16:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="HirKFa3Z"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D51A08C6;
	Tue,  9 Jul 2024 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720543382; cv=fail; b=Zco16vZw5OcBwFmmxr9LHbVlLrnhC240GA8c56SXk96jjKGylPFR4P6OWHfyybWah0XHXTcBHhN32z47pgc1bcSJsC2wNj5AS0nPhI09gcDIHYZKEwHy5hTPYtzot4/LqzrF8d3j1UhDj2GWpD1h4L8Ap774i4f/aS2e6TO41/I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720543382; c=relaxed/simple;
	bh=Sy7kg30DIqITR9jLngLeUthSzE97av7tdO+IxYu26hE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bs/0uXXRKKJhAxsn+IQK2GAaJ8dHYeFDsmF75L7ERmzTvyfX0smyIqZrd/ZPU/M5zFPNaHR+0hiur1mhArc/ufaRboAQioMUi0n8Bd/51G8C495m2QTqD4dyYqzWtcJxx07h1Qa9Mi6dSOkAgmQDzHNwNHAGculmj/OqWOuV/b8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=HirKFa3Z; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469Exv9q000723;
	Tue, 9 Jul 2024 09:43:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=Sy7kg30DIqITR9jLngLeUthSzE97av7tdO+IxYu26hE
	=; b=HirKFa3ZnkvW6pYKecYfMCYtMsHmqJ2OvmRYzcDdIFYIuSMWCkeIoCGB6og
	TNtq0QhAYXllPWY8onrmpql14EBPZBUQm8ZuPG1UCF8rGAToxL9bQDpbXMHZAQ6e
	v/xqdiIvCdpnOogAiWunGkgevj7grHFuO4osXOqJynH3jZRvEijbdxSc3TB58iht
	kzdCU6z6vwd1f6Nx00dP7vxjfMVB4XqRh8qfd4Y/vGdjXYfD2WmB6i/mbsdtb4j/
	zh7jmDyDSAIZySwUITDFWMwLi/uxNcpI3JQgDBCClHSwNyudnLSqXQQ12ZjJR+5X
	03q+AKpKIxY907lvyyjbntaRcwQ==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 408umfcdcx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Jul 2024 09:42:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cw/81QQmsHRK2I/4fyDxiSfDnHfDu5iuapnTGYVTrGU2EF5KaHiwyUXZc/V1vaWDTzIt6nZQy3C9t2jM/8XxSeUyqccyfkaKI4OqCKmO/Dprp3u/6/ozAluh2f6UtYChTG67zXZP/ILAyNXptjsPMLjN/Bafa9vBDSTbMfctDDtn50EQNx9oYS+psVpy5Fx5r7Weg2oHu3RDUeqN9/WCUrg24Lwj9I9TPtg3hxvEivligApXRd5DQz9qwFE7fj9bAE4/+TVt6cnrT9TTllYvZUg3oSGOL9pCnW3xBpRktILmPbdvsKYVkAaKKwYngtRmVtQ9rPnM99vCuKWZg1XeMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sy7kg30DIqITR9jLngLeUthSzE97av7tdO+IxYu26hE=;
 b=KWaFXAnbCiZ9cTpFEBdk5px3SJPfK8cVpVZ5QsI/E6854VlcO+v2ZHDVI8/+GSUz/mmwjC2SeW/w7YCKDnfyrMKSJAszUQL+0tRCoZPBUD6Z9zqxNY9Tue9OPGmgyNerOBSu1a2Lyq/pacGKk81zdvbvOkbTuoP5OUbjHBh+pyI/oPOKqD0K99wUe12y3fcvzSmX98o5l57LaJMDBDIky3dNnsWBU48W5X0BXykz5Ngj0s+8I/lfpPVKalxnAH1uNU6jxwrYbnaE61b5dyhXLWo2VQk5AhCLhtPMDB4NecQdLm36G2MTR0uiCcNbeW8rZ2MG7GUMew81VXaZCX6cWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5117.namprd15.prod.outlook.com (2603:10b6:510:c4::8)
 by SA1PR15MB4610.namprd15.prod.outlook.com (2603:10b6:806:19d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Tue, 9 Jul
 2024 16:42:56 +0000
Received: from PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9]) by PH0PR15MB5117.namprd15.prod.outlook.com
 ([fe80::90bf:29eb:b07e:94d9%7]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 16:42:56 +0000
From: Song Liu <songliubraving@meta.com>
To: Sami Tolvanen <samitolvanen@google.com>
CC: Luis Chamberlain <mcgrof@kernel.org>, Matthew Maurer <mmaurer@google.com>,
        Petr Mladek <pmladek@suse.com>, Gary Guo <gary@garyguo.net>,
        Masahiro Yamada
	<masahiroy@kernel.org>,
        =?utf-8?B?TWljaGFsIFN1Y2jDoW5law==?=
	<msuchanek@suse.de>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Andreas
 Hindborg <nmi@metaspace.dk>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Miroslav
 Benes <mbenes@suse.cz>,
        Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        LKML
	<linux-kernel@vger.kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>
Subject: Re: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Thread-Topic: [PATCH] kallsyms, livepatch: Fix livepatch with CONFIG_LTO_CLANG
Thread-Index: 
 AQHatveKoddWXNZdREGQxTAQ89wd6rG8SQQAgAA/fQCAILWegIAAV2+AgARtaYCAAqqmgIAAoFeAgAEl2wCABxsWAIAAKwiAgAEWKgA=
Date: Tue, 9 Jul 2024 16:42:56 +0000
Message-ID: <11313BE0-1CE7-48CF-A71A-320A883FE14E@fb.com>
References: <20240605032120.3179157-1-song@kernel.org>
 <alpine.LSU.2.21.2406071458531.29080@pobox.suse.cz>
 <CAPhsuW5th55V3PfskJvpG=4bwacKP8c8DpVYUyVUzt70KC7=gw@mail.gmail.com>
 <alpine.LSU.2.21.2406281420590.15826@pobox.suse.cz>
 <Zn70rQE1HkJ_2h6r@bombadil.infradead.org> <ZoKrWU7Gif-7M4vL@pathway.suse.cz>
 <20240703055641.7iugqt6it6pi2xy7@treble>
 <ZoVumd-b4CaRu5nW@bombadil.infradead.org> <ZoZlGnVDzVONxUDs@pathway.suse.cz>
 <ZoxbEEsK40ASi1cY@bombadil.infradead.org>
 <CABCJKucSUA_fc1eWecWAZ3z8J-T=s5zsZunJHF2VgB=9V5c3tA@mail.gmail.com>
In-Reply-To: 
 <CABCJKucSUA_fc1eWecWAZ3z8J-T=s5zsZunJHF2VgB=9V5c3tA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR15MB5117:EE_|SA1PR15MB4610:EE_
x-ms-office365-filtering-correlation-id: 09e72b43-b600-4631-ac5b-08dca0362f3b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: 
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?TWphODlnY1pMZ1B5MU0rWU1MeU5sRmFzUjJXZE0rbjRnNk53SlBuSEk2VmVU?=
 =?utf-8?B?MXllQU9ERGtDa3RWdjJzblUrSnR4cmdQc1REMjc1eWttTHhwNjdBRHB0a2dH?=
 =?utf-8?B?N21jdEhYK1JnMFdFSDlDaWt3ZmRKR0ZNSUNkRDdCdnBCWXMzQ2Y4MFZMVVFG?=
 =?utf-8?B?ZlpNT2o3ZUZMRmJmUEYwdkJpVWlMV1FDMEtxdHVEdmI4Y2VTMVFDNHpsem5q?=
 =?utf-8?B?TVNhb2FoeFJMalpFQmd2UXJvaFp2ZEVpK21mMVdVVmNTb05lOFk1K2NUTVR4?=
 =?utf-8?B?S2N4emhjWVRyQUNBcTJsYVNRcEh5N09tK2t0M3FrMVpoVjdhYjdrQUlCdmRM?=
 =?utf-8?B?eHJKd3lFcmVLMVlBaVVLbklWQlM1UThiS3lrMHcwRHFrbXVaVlNuMi9aOWhL?=
 =?utf-8?B?YytVbjViN1N4U214R2g1R25ueThQbllWbXRxSjNOdURiQWRNZkhTdmpiaVJU?=
 =?utf-8?B?SHVPeHhEdU5HZTZCOWFkaTM0Ti9RWk1uSzVmVldTNVh0MUk1d2ozajlsY29J?=
 =?utf-8?B?Uk9FUUJWdWZJNGFVU25VUHF6YjlJYWlwYmxKZmFqLzQvM3JPZmV6cDlRMGhh?=
 =?utf-8?B?eFhaYTA2STdTeEUrbVZHRDdRdlpsNkJzY01rdHN2a0UxRFNmL21LNlpyNEJk?=
 =?utf-8?B?Y2VucWM0cWJvcUZUSFg1WDRnWGZMUXdGcEVVSlNNSFNJNFdxcmcrWmNJTjg5?=
 =?utf-8?B?T0lEVzl4Zy9NRUR0clNVMWh5aUErMkk2WWtRQ0pQYmROalJyOGRlSlJJc2hS?=
 =?utf-8?B?SlZkT3FKMHZvK3FpT0ZON3MrWWp6RERUMFB1aUJYUWNJTm9GemdJOGJOMERr?=
 =?utf-8?B?cCtwYkpjVWUxZFk1ZHlObjV6OWJ2YzlaWUY0TVFFVS9qY3hVYTFLR0FCV0hs?=
 =?utf-8?B?bXo1aDNqSyszdUIwM1ZKaVI4bmtLaFhyeGlQV2JWQWkxTXlGWENxK29ZbVNm?=
 =?utf-8?B?cCtzQnlYTHZBNDY1UmFBWVpjcWwxRFFFVDNuYjhRMTJPSmdKWHJ3eFJxVk5Y?=
 =?utf-8?B?a3hTdkkwY0xFWWJCc01pZDNlOEh3bnRuNDJTS0ZLejhTUnl4eGUxNUtVYWJ3?=
 =?utf-8?B?NThtVVlaWXYxcXAwZUxpL3poQmxLVXM0QkdSU2V5SVNtYzhzbWJYK0h2YTl5?=
 =?utf-8?B?djFSVWZ0UGd3UWVTTndQSG0xUVMzbUxldVlsYkg2Wmkxbk5jdnFEeTNHODFm?=
 =?utf-8?B?cjZ5cCtBb3NiTXBGNG1VTWE1WVg1UVV5RlA3QUZiZEJPYjUzL0RjMEZwWTl4?=
 =?utf-8?B?QTlSdVdLK1FCZUNQOE5hWFltZ0RmWkdNdDNPSEJjTXE5alZsOWFnQWlBMWNG?=
 =?utf-8?B?OVhweU0xRG84WDQ1bFJnU0w3Vy9QdnJMTmFHNkZhbElaaU1Mb2R3TEFPWVdp?=
 =?utf-8?B?Y3ZRS2NxZExhdDNhZ2lKWlY4bS9FdWk5cU1kZXMveU12N1FJVEYwQ2hHYlpG?=
 =?utf-8?B?RDk3ZWppLzUwWDBlWk1kTnBmRUFxd0cxNEpES0NSekNZZDBHSnBjUEpOOGEv?=
 =?utf-8?B?MXNMNXBjVzZFYnFSZGhsUlJFWDB0eldOSkRXT1dRM25nMHhXWm8yREFQR2VT?=
 =?utf-8?B?QXcreFlvTGlTY09kczFEVVlPL1ZkUVlONHNmR2dIS1lFTi9nYnZBS3NHb3Vq?=
 =?utf-8?B?WjVXaEgzb3hxMURGUUQ4Rlp5OGU0MHBkUVhEeXJtbGtmbWk3eVIvb3NtRjI3?=
 =?utf-8?B?TnVpdXhTK0FOMElvVE1SRVk1MFlmaGF0bjF4S01VRWN4bWYzTFFyMnArb1ZB?=
 =?utf-8?B?a2wvYUtKTW5GbjZFQ01reEp1NUxpMFJSVVAzU1NMY0RGb3NVbnFWakdHWkMr?=
 =?utf-8?B?cW9IM2pWdzRNdlgxcGI2bC9ad3cxMkZkRnJXbHd3M2NTVWk3UFIxQTRFZktB?=
 =?utf-8?B?ZW9wUGtuNzRRTlA5b0w1OS9OQnNNemZLeDQvTlRNOGFjSWc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5117.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?WnllczRtQXhuSWRQZmJWelFYd3JsTVB4R3V1YjFXYUhKb1NmR0pRRjUxU0tI?=
 =?utf-8?B?SmVTWnMwQU91dHptWXlqcVVWbDNYN1A1OGhxZEJ1bFJKNFgrYnhNUnFzZE9I?=
 =?utf-8?B?TktlR0FkZGt2RW1uTEJJTU0rRlBnUy9UQWhNNitSQmQ2eEU1S0ExOW1SV0c5?=
 =?utf-8?B?M2VndnVxa1Y3R3I3eUJ1NWNXN2VwVFRiZEgwcmVQeUpTbXdxUUl3QzRTY3No?=
 =?utf-8?B?SC93TGNUSHZzSnpVVkFhR25YeXc0d0ovVFpmK2V0L25kTEZrOEJHdmxtV09v?=
 =?utf-8?B?WStxRUllS3lVVjRtZURyaVBGNVNiWnpES0FFZmR4K3MrSzRuR3VVbnpBOE5h?=
 =?utf-8?B?RWF4YzVTbTZXV3NQTloyMkRiL2NRNGhWNjFUWStqNkxzWEgyZy9iendxRkxU?=
 =?utf-8?B?Q1c4N3Y2S0pHUzBXZ2lKeWhsNW1HeEwwd3RKWXQ4SnB3YjNQRThaaVB6VVox?=
 =?utf-8?B?UjYvVGxYb3dqVVBOWTIydmhOakR4WjJVZklmRHdWOWV1Sng1SXByUnFtanNE?=
 =?utf-8?B?M2pSdkIrL1N1YmZONDhsaHJrWTlHZmQ1YkZ5OGp1RXBPR3o1ZXYzekxzRjFY?=
 =?utf-8?B?dWgvbHBkZG9BUDdaQXBSOUFBTXVSTk1YQzZYNmtRL0xySGZDT3pDQWxZVE4z?=
 =?utf-8?B?OHZNS3VnSkcva1JSa2lYMm80SlZrYStIVXdoYjYxb01idXNXRW1rNDNJOVhi?=
 =?utf-8?B?QXJ2MmlwSXkzY1RlYW84TzdHRDByVUprK1YvUjVpRnhFT04vK2V2L1kyUjhy?=
 =?utf-8?B?WjRhOVBjN3dXNmVvMzFibG5FellTbXBXdHk2K3J5TDBsRzMyWW0yQnlnYU1H?=
 =?utf-8?B?ZXNQVTJmdjlYMUhqZkN1eEt3S001VWZ2M3JzNEhUbkdwZmhsb1Jpd0NiOERt?=
 =?utf-8?B?d2dISU5iNjZhTERwWnhmYUtBeldQaHZHUnlFbHQ5d1E1TzhnTUU2TmZlM3h5?=
 =?utf-8?B?NGtsbWxvTEUwdmxnemMyMVVOVDd6U1JiQTJnejRudDl0TStvcHcwS1kyU1Bo?=
 =?utf-8?B?bzVZdlNjSHBTTGFROFplbVl0K2ljWE9MMHh3SFpFMVFEUFdSTzBnZ3RiS0kz?=
 =?utf-8?B?UHljb0NmZFhuSzBRb0F5MndUektTcmpkRlNGQWxiSENhZkRZN2Fvei9jSkNI?=
 =?utf-8?B?djVZbm5JSGlKZVJqOWpNZGRqQU1VQTU5bXRib3RqazlycTVjQlE4dkdwQnhB?=
 =?utf-8?B?NW1QbWZyOHVIek1DcnhKcTkxK3VCWmk2dm1MQkxqWWRUSjRoWE9mUGgySEIx?=
 =?utf-8?B?TllVZUlLRHFrQlBobHk1TGFKNFJIc2FrblNoeXExcU1sLzBqM2Y3LzJrN3dZ?=
 =?utf-8?B?NHozMDFBUmZkUUJ3N0tacmZTclNqb1pKMk9TclF6dXFtZVFrTmdaUEw5M290?=
 =?utf-8?B?bDhNbXFnbW9XYUt2SVUxZFptRFUzR0hqazVXVDNhSmFEMEM5WlM3VUk4ald0?=
 =?utf-8?B?WVR3M2JLRVByT1JTS1ZLQnlFWjR1VFFzeFFXcktFdldsOHZLK0h5MmoveElN?=
 =?utf-8?B?UWxuMlRheE53QU0vNnRnWWRudkx3S3BNQnNnSlVYQ0drWnY4UEl6aVdTSUto?=
 =?utf-8?B?bndodTlnM2NXekpXRDhLT2JOZHRzNlhIN2FHR0JzcUo5Wmh5SDVPZElMbUdE?=
 =?utf-8?B?L0twbDUvd1F4akdXQVpvWCs2QlByMGxxTzhOd0FxYUkrUmlhNmRLbmRaaVlC?=
 =?utf-8?B?aFFmM0p0bFNualoyRTQwdFZPN05OdGlraDdQUWk3WFNLUnNweDExaVVrQlNU?=
 =?utf-8?B?SnVoWW5KWU5kL3NWQzd4RjNIU21yQTFmZy9vRzBERWxjQjBLYWVlVi9pZWwr?=
 =?utf-8?B?aE93NzN6dm1zeVVEcFRxeEhRcXdCYWJhRmt1aWgrdHdpWTNZVzNYdDd3TFRF?=
 =?utf-8?B?MTdQUk1MSUZ0eHFmU2tqcFAvV0labEI0MHFSMFhDaUFMUWkvWWdwTjcwVGt3?=
 =?utf-8?B?bGJ1WGZ0UFNOVC9MOUROYkg3KzRoWWdlaFdOc1VoaDArM2pWeHZLSkhBSEIr?=
 =?utf-8?B?WERPejBwVXFnVUo5cjB3MkkzVVJ1enJTT2ZzNVRyMXM3ZzFTekpDTGtVMmF3?=
 =?utf-8?B?a0RhSG1jVE1qM1RFV25RNUNFQy95QXR2WExIYmJFZFZYU2hteUZkZ1pGaEND?=
 =?utf-8?B?d1RPZEhkSVJ4TE1KNGQ0Wk83bFFmYXgzT2lwM0JrOGRqbDdGNjNwbWQ5djll?=
 =?utf-8?Q?+4L+Mf2M3j0DQ0619VumEwg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1E1BBA888702F44982B269891537C40@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5117.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e72b43-b600-4631-ac5b-08dca0362f3b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2024 16:42:56.0710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WXPS5kMP6KNS6G8tDlcm5gZLjxds+a6SrL+j0qzY/bYpvBbAq8kGLJoLkW91BEzqt3bnAPPex2JPBaVs97KwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4610
X-Proofpoint-GUID: L7AW139PqelqgJ6k22X-yetYBztheQ85
X-Proofpoint-ORIG-GUID: L7AW139PqelqgJ6k22X-yetYBztheQ85
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_06,2024-07-09_01,2024-05-17_01

DQo+IE9uIEp1bCA5LCAyMDI0LCBhdCA4OjA34oCvQU0sIFNhbWkgVG9sdmFuZW4gPHNhbWl0b2x2
YW5lbkBnb29nbGUuY29tPiB3cm90ZToNCg0KWy4uLl0NCg0KPiANCj4+PiBJIGFtIGEgYml0IHNj
YXJlZCBiZWNhdXNlIHVzaW5nIGhhc2hlZCBzeW1ib2wgbmFtZXMgaW4gYmFja3RyYWNlcywgZ2Ri
LA0KPj4+IC4uLiB3b3VsZCBiZSBhIG5pZ2h0bWFyZS4gSGFzaGVzIGFyZSBub3QgaHVtYW4gcmVh
ZGFibGUgYW5kDQo+Pj4gdGhleSB3b3VsZCBjb21wbGljYXRlIHRoZSBsaWZlIGEgbG90LiBBbmQg
dXNpbmcgZGlmZmVyZW50IG5hbWVzDQo+Pj4gaW4gZGlmZmVyZW50IGludGVyZmFjZXMgd291bGQg
Y29tcGxpY2F0ZSB0aGUgbGlmZSBlaXRoZXIuDQo+PiANCj4+IEFsbCBncmVhdCBwb2ludHMuDQo+
PiANCj4+IFRoZSBzY29wZSBvZiB0aGUgUnVzdCBpc3N1ZSBpcyBzZWxmIGNvbnRhaW5lZCB0byBt
b2R2ZXJzaW9uX2luZm8sDQo+PiB3aGVyZWFzIGZvciBDT05GSUdfTFRPX0NMQU5HIGlzc3VlIGNv
bW1pdCA4YjhlNmI1ZDNiMDEzYjANCj4+ICgia2FsbHN5bXM6IHN0cmlwIFRoaW5MVE8gaGFzaGVz
IGZyb20gc3RhdGljIGZ1bmN0aW9ucyIpIGRlc2NyaWJlcw0KPj4gdGhlIGlzc3VlIHdpdGggdXNl
cnNwYWNlIHRvb2xzIChpdCBkb2Vzbid0IGV4cGxhaW4gd2hpY2ggb25lcykNCj4+IHdoaWNoIGRv
bid0IGV4cGVjdCB0aGUgZnVuY3Rpb24gbmFtZSB0byBjaGFuZ2UuIFRoaXMgc2VlbXMgdG8gaGFw
cGVuDQo+PiB0byBzdGF0aWMgcm91dGluZXMgc28gSSBjYW4gb25seSBzdXNwZWN0IHRoaXMgaXNu
J3QgYW4gaXNzdWUgd2l0aA0KPj4gbW9kdmVyc2lvbmluZyBhcyB0aGUgb25seSBzeW1ib2xzIHRo
YXQgd291bGQgYmUgdXNlZCB0aGVyZSB3b3VsZG4ndCBiZQ0KPj4gc3RhdGljLg0KPj4gDQo+PiBT
YW1pLCB3aGF0IHdhcyB0aGUgZXhhY3QgdXNlcnNwYWNlIGlzc3VlIHdpdGggQ09ORklHX0xUT19D
TEFORyBhbmQgdGhlc2UNCj4+IGxvbmcgc3ltYm9scz8NCj4gDQo+IFRoZSBpc3N1ZSB3aXRoIExU
TyB3YXNuJ3Qgc3ltYm9sIGxlbmd0aC4gSUlSQyB0aGUgY29tcGlsZXIgcmVuYW1pbmcNCj4gc3lt
Ym9scyB3aXRoIFRoaW5MVE8gY2F1c2VkIGlzc3VlcyBmb3IgZm9sa3MgdXNpbmcgZHluYW1pYyBr
cHJvYmVzLA0KPiBhbmQgSSBzZWVtIHRvIHJlY2FsbCBpdCBhbHNvIGJyZWFraW5nIHN5c3RyYWNl
IGluIEFuZHJvaWQsIGF0IHdoaWNoDQo+IHBvaW50IHdlIGRlY2lkZWQgdG8gc3RyaXAgdGhlIHBv
c3RmaXggaW4ga2FsbHN5bXMgdG8gYXZvaWQgYnJlYWtpbmcNCj4gYW55dGhpbmcgZWxzZS4NCg0K
VHJ5aW5nIHRvIHVuZGVyc3RhbmQgYWxsIHRoZSByZXF1aXJlbWVudHMgYW5kIGNvbnN0cmFpbnRz
LiBJSVVDLCB3ZQ0KY2FuIG1vc3RseSBhZ3JlZTogDQoNCigxKSBBIHdheSB0byBtYXRjaCBhIHN5
bWJvbCBleGFjdGx5IGlzIGNydWNpYWwgZm9yIHVzZXJzIGxpa2UgbGl2ZSANCiAgICBwYXRjaGlu
Zy4gDQooMikgT3JpZ2luYWwgc3ltYm9sIG5hbWUgaXMgdXNlZnVsIGZvciBiYWNrdHJhY2UsIGV0
Yy4gKElPVyBoYXNoIA0KICAgIGFsb25lIGlzIG5vdCBlbm91Z2gpDQoNCldpdGggdGhlc2UgdHdv
IHJlcXVpcmVtZW50cy9jb25zdHJhaW50cywgd2UgbmVlZCANCg0KICAgb3JpZ2luYWwgc3ltYm9s
IG5hbWUgKyBzb21ldGhpbmcgDQoNCmZvciBkdXBsaWNhdGUgc3ltYm9scy4gIlNvbWV0aGluZyIg
aGVyZSBjb3VsZCBiZSBhIHBhdGggbmFtZSANCih4eHhfZHJpdmVyX3h4eF95eXlfYyksIG9yIGEg
aGFzaCwgb3Igc3ltcG9zLiANCg0KQXQgdGhlIG1vbWVudCwgKDEpIGlzIG5vdCBtZXQgd2l0aCBD
T05GSUdfTFRPX0NMQU5HLiBUaGUgb3JpZ2luYWwNCnBhdGNoIHRyaWVzIHRvIGZpeCB0aGlzLCBi
dXQgdGhlIHNvbHV0aW9uIHNlZW1zIG5vdCBvcHRpbWFsLiBJIHdpbGwgDQpzZW5kIGFub3RoZXIg
dmVyc2lvbiB0aGF0IGFsbG93cyBrYWxsc3ltcyBtYXRjaCBleGFjdGx5IG9yIHdpdGhvdXQNCnN1
ZmZpeC4gDQoNClRoaXMgd29yayBzaG91bGRuJ3QgY2F1c2UgYW55IHByb2JsZW0gZm9yIFJ1c3Qs
IGFzIFJ1c3QgYWxzbyBuZWVkIA0Kb3JpZ2luYWwgc3ltYm9sIG5hbWUgKyAic29tZXRoaW5nIi4g
SWYgd2UgZmluYWxseSBkZWNpZGUgInNvbWV0aGluZyIgDQpzaG91bGQgYmUgc29tZSBmb3JtYXQg
b2YgaGFzaCwgd2UgY2FuIGNoYW5nZSBhbGwgdXNlcnMgKGxpdmUgcGF0Y2gsIA0KZXRjLikgdG8g
dXNlIGhhc2gsIHdoaWNoIG1pZ2h0IGJlIGJldHRlciB0aGFuIHN5bXBvcy4gTm90ZTogSSBhbQ0K
bm90IHRyeWluZyB0byBzYXkgInNvbWV0aGluZyIgc2hvdWxkIGJlIGhhc2guICANCg0KT1RPSCwg
dGhlcmUgaXMgYWxzbyBhbiBvcGVuIHF1ZXN0aW9uOiBTaGFsbCB3ZSBhbGxvdyB0cmFjaW5nIHdp
dGgNCm9ubHkgb3JpZ2luYWwgc3ltYm9sIG5hbWUgKHdpdGhvdXQgc3BlY2lmeWluZyBfc29tZXRo
aW5nXykuIEkgdGhpbmsNCnRoaXMgYSBzZXBhcmF0ZSBxdWVzdGlvbiBhbmQgd2UgZG9uJ3QgaGF2
ZSB0byBhbnN3ZXIgaXQgaGVyZS4gDQoNCkRvZXMgdGhpcyBtYWtlIHNlbnNlPw0KDQpUaGFua3Ms
DQpTb25nDQoNCg==

