Return-Path: <live-patching+bounces-430-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 248B9946244
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 19:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95C2D1F20FDB
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 17:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 097211537A0;
	Fri,  2 Aug 2024 17:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nmm/fkq6"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2985F16BE06;
	Fri,  2 Aug 2024 17:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722618560; cv=fail; b=INghd/bLDqCRR2EFehRzst8ra0xzDIWrZgSE8eeYdvPaM0UbFWU3UALCdPpKZqynGnEPGv5Wgcq3io8gEotM+J77LckQm2Sa1QOLwqaiOcpcOj+TP2Q/KNEEfLzeYG/qb8ezAtEXgThl7C6/8K1t8HhpsfIO1s3MYkAuCj1aBz0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722618560; c=relaxed/simple;
	bh=c3K+nxy+cUOxAAnJZzPzvJRnuVmuEYMQ8TRQm8vQoIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=e8nxmnOAmSw2Uj9JEDWSk3ehGMtoBCPGY/GKfmvyeDdbAyJwOwYFnAFSWiHZJfHQlifwCLveROZB/Kmus0QdFHGIErhg1WcKbM4J10Fl/S7A4xAbu3VBDDXoTLnfYl49lQMTC50G0FIGWKfVidoQJFUTf+5Z4/Xwv0kAcqTFfI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nmm/fkq6; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472BjJTu021972;
	Fri, 2 Aug 2024 10:09:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=c3K+nxy+cUOxAAnJZzPzvJRnuVmuEYMQ8TRQm8vQoIk
	=; b=nmm/fkq60SHydNVvobWgvjNtbrzHuzbV9EiaxgpIqrDZMnWP3oQUd+9+dza
	D5l7CfU+BjCd/EKnbfRenDoGW5hFPM9CEIGHoCpqTs04JOR/Lp7y7MDTXENkYFKE
	8mYE2kcK/Z3JAtDmgIrDvhOUWPsP3NTxoKMohBVf0QvtUyVVUEgTSnJpsqAU4Gmx
	gf5a6RSbU4dwzw0GKXo+jlpNz+/r+V65vPCb1UxY0PQ9e2RtoLULcgABmx1Nw1CB
	CKOtX+hRwDTpkSr+FOoI5IVWShZ7nPPsgrPW21+IX5ZspGbB+9TY+92H8N0YRNOo
	Esgh8RiTkbAMvFLiChW/gFe/HXA==
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40rjeu602a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 10:09:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rs4dlUbAsDQtv7Ggqv9QeE5P4iXDwY1Kk3PBs1bAEZrRukKWWnTGaURrRZ9PXYfDDMw6sfiujOAAFGejNCV3Jt/7bOaz2OCuQvs2hd1XeQ6hJwnuqTuOXuNVZAFdjNy+MrATrgQC7GoooqxfK5ENrKkMBL7Eb+38y7DqttbiEG29LPeW76gem9X3qheCxTFn9P2LAd/VdrP98AL1jP1CrjsFJwMT2G7CdzEiaF+Nlw8Ycd5ZSX4tDqO4UMUuWm1g34FYZGejRNuEZMgclsQzylkD1bgF6OM0x7+4npvI5rOqDE6wVyJYDwVJECBm1j7t3AlcoaVll+St9SKFYQ+hUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3K+nxy+cUOxAAnJZzPzvJRnuVmuEYMQ8TRQm8vQoIk=;
 b=jOMMCuZMUGxaRt8LHnBEU/kYLnHKOvdFE8HBiN2iPP+km1eF9fXDwyPAXdU8CW8AGn1+F0ekhI/exYFBeUbLpzayRqSwIpMRj11eRUC0ZrH6/itJ+zLauULCm9h/wnkR4WBnjpFDvBRDlMCuEhJfnRuSr+m1Rdb+NBaNZcBozWErUUDSKvoeFKbUtK+6PGY66rrs5q8e68fXnfw5+4V2a+qgjEtX8uY/IXkXVU4HKNFRxDZ384L1WO7SMFfTG2nF/ojnUVHTT5A2uZQN6lj9fpXjxhxGdWVCDCo+YPn874klQP/rxEcW+0ZzV72SVTDXJKcVN9XtvbrWW/G+uWMs6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BL1PR15MB5340.namprd15.prod.outlook.com (2603:10b6:208:387::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.22; Fri, 2 Aug
 2024 17:09:12 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Fri, 2 Aug 2024
 17:09:12 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <songliubraving@meta.com>,
        Masami Hiramatsu
	<mhiramat@kernel.org>, Song Liu <song@kernel.org>,
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
        Sami Tolvanen <samitolvanen@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Topic: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Index: AQHa4hsdZBHaq1mnRkygDON43y0YhLIPPWoAgADIbACABBvegIAAF2yA
Date: Fri, 2 Aug 2024 17:09:12 +0000
Message-ID: <2F42C167-319A-46F2-A6C8-95B59F675D65@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
 <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
 <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
 <Zqz_BwG1fcQaUsoY@pathway.suse.cz>
In-Reply-To: <Zqz_BwG1fcQaUsoY@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|BL1PR15MB5340:EE_
x-ms-office365-filtering-correlation-id: e8beeed3-d8ba-469c-12be-08dcb315d4dd
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?THJWVVhJYlYxQXFtcHhNQW9hTTd6OE1CZW5BMVBJMG9yWmI5UTB4TzRNUnFx?=
 =?utf-8?B?bDVwenF3RVVMczVUdi9yN1FHZGFLemV6bTJKZ210U3A2UHRBWVFSK05yckdM?=
 =?utf-8?B?VE56WlhFWmdqRWp6WjI5TkZCVFVmRmhmK1ZPYjdlem5Xdy9YaHgrbWlBZVBW?=
 =?utf-8?B?R2Zud1I1dE5nY05SdUlQcWFBSE5QL0tiMytVS1ZqYnU5Yyt1QWtxeUZYZ1pJ?=
 =?utf-8?B?N0d6a3JFZFgvYnlMSzlZNFh5eUo3b0g2MytZRVV4U1BhOXRLeVRMV2ttRVQw?=
 =?utf-8?B?Yytac0xtMmd1RXEvZGl6ZENqYTRKVmx2MGpLcHhWU1VxOWRVa0tSTFhSRDFn?=
 =?utf-8?B?c2p5YXZqU01sRGVoNmNWVFZzSndWSTRWeGptdjM5Qzd5TFVKRE1IdXA5clRr?=
 =?utf-8?B?Z1dIcS9ZYzFtSUhLR2xGaGdIQlNyN0I3RVRDUGgzS2E4cFlQajhub3NiYU5S?=
 =?utf-8?B?Vk1DVXFzSTRhRlBpY3dGZTBxVG1NQW9aRm9EYXAvNDBscXBWRFk0L0tyNmMy?=
 =?utf-8?B?cTdaTm1tV0J2ZnczMktmZENQTkl0aFoya0lhWHJ4dThIdDJBT0ZkTnpmdVVP?=
 =?utf-8?B?V296SEhnWlB6KzE3eDR1OFBmcTE2aFNvZTBJTFVHQk4yVGZDbE1RSitHaTlm?=
 =?utf-8?B?UElCWWIwYmVEcWVrU1RCc1lpTGFpQktaMEhzOGdDWVBvaXJGZ1g3MmlNcXJk?=
 =?utf-8?B?cUVPTzRqNHFnMy9lbG5LSmhIVE5tVDFFelN3V0hGeEFoeE1ZbEhHU3Z6Q0Ni?=
 =?utf-8?B?a0NCTWs0K2IrZ2hSRDlGcWdiRlYrLzcwclBXNStmbEhwUVh0ODZTK1R2S0pL?=
 =?utf-8?B?UllucUZRSUFMV1M0bExCUC9MYlArVHdGS0RadmlYSlJ3MWk2b1daYmJhVEdH?=
 =?utf-8?B?M3dvbFA0TkljdFdQRnNKeElzYVFwTityQlE2RzhDSVhtVFQxNlN1aFAwQm5w?=
 =?utf-8?B?QnpTOU94THlydUJodjNXRlhHOWJ2RDAwQWFyc1M1cVhNZlhHRXRYNktyWDcy?=
 =?utf-8?B?N3RZU2l6NTEwRFB0ZEoyM01aRFR2SU42cmFXL3ZVc0plcWtNQnZRV2lFampR?=
 =?utf-8?B?SkFLU09URDRYYmRUcmdTdit1TnRZNlM0dy90QkI3b3Y5RHdSOHZBSUFjR1Jk?=
 =?utf-8?B?Ym14K2tpdlRtY2V3WGdJbURoTk9waXlaMzA2OFhEVU44TFBYaEdWZGVxcWRT?=
 =?utf-8?B?S2swL2xTZXIyRjE1QWtvNTdmeFdRMUVxMWxUVVRXSHFXaHc2Uzk3YWI2Z0p2?=
 =?utf-8?B?alVZcmFjOWNSNWxLYU5TYzNsU0NudmNNQzJQMUNIY1ZuL3FrR0U2RlBGSFAv?=
 =?utf-8?B?UkpNaXdxUlh2SUN3ejhsK3NOQzNPYXp0WHgya084MExKQjQ4c25nU3VsTUww?=
 =?utf-8?B?UEgvaUF1a3QwVHJ0VGtMbXNVdjdFbEhtckNqa2JLMGVpOStJS2hUUXNxdDJl?=
 =?utf-8?B?c2ZUWHJGd21oSTRxSm1FSzZtZEk5bFpXdTF0U3FRbWI5MW9JVW10YUlMTmwy?=
 =?utf-8?B?cUFIUk03TzdUL1ZQVS92MURlcjE5dFlyQWtuUVlUQzI4NTdZenlXYng1SWxS?=
 =?utf-8?B?OGdQNVBCejU0NTA3T2Z1ZDBRcnk3NmRRTm8rY0d5RjJvMTA3L3lDQ1VZZmRn?=
 =?utf-8?B?a09sQllpR0Q4cVRYMFZCMXFSNTc3dEdCdk1DS3h4QkNvNm04NXozdWRsSEFi?=
 =?utf-8?B?Y3RWZ29GV1hiT0NYN2FZcmtrbFhCc0xqdkpDYzU1THUzQXBDSTlidkRaREEz?=
 =?utf-8?B?WnpnYzhDV3RSOENBa25lcUJ6VzRUOFROZEYxZ1VWeTYrck4yaUJId3Z0L0hR?=
 =?utf-8?B?YmlHSzlKVUlxd2JVWlZlYTEwMTltRytyc1M3QWJuRnkwaU00K0Nrajl1MHdr?=
 =?utf-8?B?QmFxc1RLbUh0cXQyb25EZUlXR3daNy96bWo3N0tmR3hWVWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?REdzRXhhUytaWHBCd1Vua3gvNVdQNW9udTdBaVpEVHlYL0NCQTlQU3I1NGV1?=
 =?utf-8?B?TXlxU2dQUU9BVktramJVbkdWTklnREtpNm1BTmNjWStadmM1Q0ZxeXR6UW85?=
 =?utf-8?B?eTlhZWtkMWRpK0xacXRGREd1dGhNSW5UYTZqQWo1R2s1L0hBaUdQd1VwTjhs?=
 =?utf-8?B?RHN1Skl4S3A3RmFTSjQ0ZnRzdExCeW9ibHpyejRlQVloNTM5RmF5SFZBQjIy?=
 =?utf-8?B?b29LVEVUaWxTeExkMmE3a29KNjNXc3AvbWhrU1pJMDNaQkp4bU9HeE5RVzR4?=
 =?utf-8?B?dGdSM2lUb0p2dW1sN0p6QWRNdFlCYTRMNU9tM3lDelRLb3pEcUt6c0VJWFN3?=
 =?utf-8?B?VndEZU0zN2t5OERDMnk5djhCaXE5bTRITndBMTdnMUo1eWRMdUJIbU5Xdk5D?=
 =?utf-8?B?RmRMT3FaVE9ZNGVCOHhpdmpwa1E0d0Q3NWcrRGt5TGtwODdURi9lcFNiVE1X?=
 =?utf-8?B?dmVVYksyazRDcW5GVEx5V3lJeUEzS3cxVVZjY0I4NENZdVI5cnFOSUttSmR0?=
 =?utf-8?B?cDJVemoyQ0RxVWthMmt1TVRGempiUUNMK0VTcFVuY0R2eDFScnBKNVF3Q1JY?=
 =?utf-8?B?VzRnRzA5U1RjTlZheXBxczlBb0tiNHpKWkNQMlNlMW1qMEJKUnRRMlNZeERq?=
 =?utf-8?B?U3pUZE84VERFaDI1SHZsS1YrMStmK2NmSlVNMmtxY1NPZU9udUtzVzJPZGZ2?=
 =?utf-8?B?TjVac3d5dTVKYWdtZ0ZEWW1rdWQ1WERZcFJ3ZUQrZFRtYW15aTZyQ254Yk5W?=
 =?utf-8?B?WndIRlRIZVFQcmlhTjdpUFlZaTE5cTRtMjYxSXMvUXVtOWhoM1R0T3F4UUNF?=
 =?utf-8?B?bmNOMmU3QzVUaDB6cng0aGhaTnFUTE9SLzlRZWorbndtYnc3bEhHdGpSNVlM?=
 =?utf-8?B?eUFCeVJiU05uN3JNZStUR2lyaXJVYUMrc0t2SExHayt6Mnl4emRYdmJVeDB0?=
 =?utf-8?B?aXY1YWYySW1NVVlXcitmTjVQeUVIdTZmNzJ0Vk4wY3UxSkwvdS9UdXhYMW44?=
 =?utf-8?B?M0VYakt0dE1TZjRIMXlHbzd5NzhDN0JwalQ5TnlpYmlPdmhUa3ZJcVk3TW9G?=
 =?utf-8?B?Rm1nSjZVeTJXMFFaZnVMaVR6Y2xLdk9sbXlySzFkMUtXQ0t2cVBueVFEVEhN?=
 =?utf-8?B?U0I4N1VEalk3S25lVk5DQVNFZHdoanhWemgvOWRTWXZmUWh4R3h6WG83dnRF?=
 =?utf-8?B?WjhQejRnYnl0b2hzZytFZlk1ZG5sdVc2MzRQczl0OWt5T1hrQWpoVk1HU3Jo?=
 =?utf-8?B?SGp2NTF5ZGRDcExsUTVGVy9mK3lvQ01YakJWc1lTSklPdVJuamp3dWlzb3pR?=
 =?utf-8?B?RDNzcFVuS2x1LzlmL2xqcGpOTnY3MGljSGgxNFIwZHNuNW5hV3VadUYvM20w?=
 =?utf-8?B?RzAvN2xqRWlyRndYMkhCSTVncXYrbDhKU2dIYWRmZm8vamRlZnlTaDVtSGFH?=
 =?utf-8?B?bWhNbXpIOWx1THV0cTNLK3A0OXpsR3NRMU5oSW1EbXpTTVp5dDVaS3Y0WlQx?=
 =?utf-8?B?cFBHTUt6R3QvZWp4MnR4VWVBRjBnVGRjVzNGbUFYQktyYzlsWTBnMTVmZDBV?=
 =?utf-8?B?c284VjZkK0JFd2tmMU1UZml0WjZGZ0FLTjhkRG9TVTlUNmlGZHR5RXJZWklj?=
 =?utf-8?B?R0RGNjZaSkVqUllzRUNhRGdIZm04d0dHZnIxUjIvN2NtZG5uSFJJYW44Yjcx?=
 =?utf-8?B?VmNDa1oxU25oRGxPOXBSOG9IZEkrdU1pQXJyQW9HY2UzdFN3KzhVTmFPZHR3?=
 =?utf-8?B?WDNCVlByZmc2dFVZdXJCdVZHZTlrNjVGQzBkNXlmU2F5RVFHLzN4eE1qcnRr?=
 =?utf-8?B?L1d5N3JaUWNHMGp6bkR1UUZKUkcvZWtSTmxCdWFBL3RJTmdmY0hQR3Z5RlRG?=
 =?utf-8?B?NFN3N1VvcWtJUm1uZ1pxUXRDNHZPdGlPcGJ4Ti9sQ21lMVR3VFRwZk1mKzlv?=
 =?utf-8?B?eWVFYXluZXpvR2pJdHpXcHc1TEdRNHo5WGhwVWNVSlN0cUlQZEdPcFJ1NERU?=
 =?utf-8?B?cFVuWWFhS2hPUnphSi8xNjBTQkl1TGdKR0NZZnBoelNSUDhjWXNPemtUQ3JU?=
 =?utf-8?B?Q0ZvME9OMFgvdkM4OWU2dlpqM1JWSVRiNHlEVmRQMVpuR2JqVkRRSEZDMEow?=
 =?utf-8?B?aVV2Qk9MZXVwY05IQ0hsVHRBeGM4QXl3WWc5MERGRjhoUi9GU0dxZDZCT0tT?=
 =?utf-8?Q?+AqdLDKGb5bt2LiaQEycKTg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <808FE046490F024F8A0E0FEAEA7ECCA4@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e8beeed3-d8ba-469c-12be-08dcb315d4dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 17:09:12.6264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8neOnz0CX5O21f6EBTzXop++RXuDJWkXrS4a5Ua/4akRaBDzTPat185t3/IlBEPCprZKCqBEI6BGghz6yr5XUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR15MB5340
X-Proofpoint-ORIG-GUID: -Bd6ypelZkXeAJTEnxrMqFAib3wO2Jog
X-Proofpoint-GUID: -Bd6ypelZkXeAJTEnxrMqFAib3wO2Jog
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_13,2024-08-02_01,2024-05-17_01

SGkgUGV0ciwgDQoNCj4gT24gQXVnIDIsIDIwMjQsIGF0IDg6NDXigK9BTSwgUGV0ciBNbGFkZWsg
PHBtbGFkZWtAc3VzZS5jb20+IHdyb3RlOg0KDQpbLi4uXQ0KDQo+IA0KPiBJTUhPLCBpdCBkZXBl
bmRzIG9uIHRoZSB1c2UgY2FzZS4gTGV0J3Mga2VlcCAicGluZ190YWJsZS8iDQo+IGFzIGFuIGV4
YW1wbGUuIFdoeSBwZW9wbGUgd291bGQgd2FudCB0byB0cmFjZSB0aGlzIGZ1bmN0aW9uPw0KPiBU
aGVyZSBtaWdodCBiZSB2YXJpb3VzIHJlYXNvbnMsIGZvciBleGFtcGxlOg0KPiANCj4gIDEuIHBp
bmdfdGFibGUubGx2bS4xNTM5NDkyMjU3NjU4OTEyNzAxOCBhcHBlYXJlZCBpbiBhIGJhY2t0cmFj
ZQ0KPiANCj4gIDIuIHBpbmdfdGFibGUubGx2bS4xNTM5NDkyMjU3NjU4OTEyNzAxOCBhcHBlYXJl
ZCBpbiBhIGhpc3RvZ3JhbQ0KPiANCj4gIDMuIHBpbmdfdGFibGUgbG9va3MgaW50ZXJlc3Rpbmcg
d2hlbiByZWFkaW5nIGNvZGUgc291cmNlcw0KPiANCj4gIDQuIHBpbmdfdGFibGUgbmVlZCB0byBi
ZSBtb25pdG9yZWQgb24gYWxsIHN5c3RlbXMgYmVjYXVzZQ0KPiAgICAgb2Ygc2VjdXJpdHkvcGVy
Zm9ybWFuY2UuDQo+IA0KPiBUaGUgZnVsbCBuYW1lICJwaW5nX3RhYmxlLmxsdm0uMTUzOTQ5MjI1
NzY1ODkxMjcwMTgiIGlzIHBlcmZlY3RseQ0KPiBmaW5lIGluIHRoZSAxc3QgYW5kIDJuZCBzY2Vu
YXJpby4gUGVvcGxlIGtuZXcgdGhpcyBuYW1lIGFscmVhZHkNCj4gYmVmb3JlIHRoZXkgc3RhcnQg
dGhpbmtpbmcgYWJvdXQgdHJhY2luZy4NCj4gDQo+IFRoZSBzaG9ydCBuYW1lIGlzIG1vcmUgcHJh
Y3RpY2FsIGluIDNyZCBhbmQgNHRoIHNjZW5hcmlvLiBFc3BlY2lhbGx5LA0KPiB3aGVuIHRoZXJl
IGlzIG9ubHkgb25lIHN0YXRpYyBzeW1ib2wgd2l0aCB0aGlzIHNob3J0IG5hbWUuIE90aGVyd2lz
ZSwNCj4gdGhlIHVzZXIgd291bGQgbmVlZCBhbiBleHRyYSBzdGVwIHRvIGZpbmQgdGhlIGZ1bGwg
bmFtZS4NCj4gDQo+IFRoZSBmdWxsIG5hbWUgaXMgZXZlbiBtb3JlIHByb2JsZW1hdGljIGZvciBz
eXN0ZW0gbW9uaXRvcnMuIFRoZXNlDQo+IGFwcGxpY2F0aW9ucyBtaWdodCBuZWVkIHRvIHByb2Jl
IHBhcnRpY3VsYXIgc3ltYm9scy4gVGhleSBtaWdodA0KPiBoYXZlIGhhcmQgdGltZXMgd2hlbiB0
aGUgc3ltYm9sIGlzOg0KPiANCj4gICAgPHN5bWJvbF9uYW1lX2Zyb21fc291cmNlcz4uPHJhbmRv
bV9zdWZmaXhfZ2VuZXJhdGVkX2J5X2NvbXBpbGVyPg0KPiANCj4gVGhleSB3aWxsIGhhdmUgdG8g
ZGVhbCB3aXRoIGl0LiBCdXQgaXQgbWVhbnMgdGhhdCBldmVyeSBzdWNoIHRvb2wNCj4gd291bGQg
bmVlZCBhbiBleHRyYSAobm9uLXRyaXZpYWwpIGNvZGUgZm9yIHRoaXMuIEV2ZXJ5IHRvb2wgd291
bGQNCj4gdHJ5IGl0cyBvd24gYXBwcm9hY2ggPT4gYSBsb3Qgb2YgcHJvYmxlbXMuDQo+IA0KPiBJ
TUhPLCB0aGUgdHdvIEFQSXMgY291bGQgbWFrZSB0aGUgbGlmZSBlYXNpZXIuDQo+IA0KPiBXZWxs
LCBldmVuIGtwcm9iZSBtaWdodCBuZWVkIHR3byBBUElzIHRvIGFsbG93IHByb2JpbmcgYnkNCj4g
ZnVsbCBuYW1lIG9yIHdpdGhvdXQgdGhlIHN1ZmZpeC4NCg0KVGhlIHByb2JsZW0gaXMsIHdpdGgg
cG90ZW50aWFsIHBhcnRpYWwgaW5saW5pbmcgYnkgbW9kZXJuIGNvbXBpbGVycywgDQp0cmFjaW5n
ICJzeW1ib2wgbmFtZSBmcm9tIHNvdXJjZXMiIGlzIG5vdCBhY2N1cmF0ZS4gSW4gb3VyIHByb2R1
Y3Rpb24gDQprZXJuZWxzLCB3ZSBoYXZlIHRvIGFkZCBzb21lIGV4cGxpY2l0ICJub2xpbmUiIHRv
IG1ha2Ugc3VyZSB3ZSBjYW4gDQp0cmFjZSB0aGVzZSBmdW5jdGlvbnMgcmVsaWFibHkuIA0KDQpP
ZiBjb3Vyc2UsIHRoaXMgaXNzdWUgZXhpc3RzIHdpdGhvdXQgcmFuZG9tIHN1ZmZpeDogYW55IGZ1
bmN0aW9uIA0KY291bGQgYmUgcGFydGlhbGx5IGlubGluZWQuIEhvd2V2ZXIsIGFsbG93aW5nIHRy
YWNpbmcgd2l0aG91dCB0aGUgDQpzdWZmaXggc2VlbXMgdG8gaGludCB0aGF0IHRyYWNpbmcgd2l0
aCAic3ltYm9sIG5hbWUgZnJvbSBzb3VyY2VzIiANCmlzIHZhbGlkLCB3aGljaCBpcyBub3QgcmVh
bGx5IHRydWUuIA0KDQpBdCB0aGUgbW9tZW50LCBJIGhhdmUgbm8gb2JqZWN0aW9ucyB0byBrZWVw
IHRoZSBfd2l0aG91dF9zdWZmaXgNCkFQSXMuIEJ1dCBmb3IgbG9uZyB0ZXJtLCBJIHN0aWxsIHRo
aW5rIHdlIG5lZWQgdG8gc2V0IGNsZWFyIA0KZXhwZWN0YXRpb25zIGZvciB0aGUgdXNlcnM6IHRy
YWNpbmcgc3ltYm9scyBmcm9tIHNvdXJjZXMgaXMgbm90DQpyZWxpYWJsZS4gDQoNClRoYW5rcywN
ClNvbmcNCg0K

