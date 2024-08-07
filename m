Return-Path: <live-patching+bounces-455-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3751E94B185
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:40:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A2E61C2083C
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 20:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB478145FEE;
	Wed,  7 Aug 2024 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="GjEr3lHU"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA46145FE1;
	Wed,  7 Aug 2024 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063240; cv=fail; b=fcCnk8SKOubr3KOdHjhZzi7qeasJg/r2unjNV4+lRHIXCOPTzCGgqCEnuc9Nw+Hidh3JRUY1Xm8LdFmg1HX1Y3DpdlljksgrSuYt6btDlJxosIs7kodbpsBq1qrOPz0RYEEP1vI6BxCab/cqOCJHhD+h0EVe50RTKeQQEPGjzRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063240; c=relaxed/simple;
	bh=t+olge0+xEVI8skFdVFJ2XvuUKLZhG0sHvWipVaD5Bk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FjQakDV6zqVPnBFGqKfzZnw6aWD14WeitHf9uGpGnvYsyUbVT056SpNKd672bndEIlrxmx/KML9t+kiWKblESroLC3Y4cNQ2o2uPFICBxppfvZvjBlBKbygGKcym2gcjTDJK3Lc1EtPJ5MkYr07lb2pgSe2TTmznnVZWGnnNWho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=GjEr3lHU; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 477JKGJA008517;
	Wed, 7 Aug 2024 13:40:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=t+olge0+xEVI8skFdVFJ2XvuUKLZhG0sHvWipVaD5Bk
	=; b=GjEr3lHU5bQVzKzZWySrMyDlSgoP+deOUP40sxh+at4vo+S3eTuvms8AasJ
	omTFQUSyyaf3EMj/bRoH5WM7mUTQ3CDtndG233MxDzQYGpysOkTw7dmbfeWCQB9e
	vrWInTn+KKgysvEcc0p1IPYPN6vuafOt9/bxpFySSYw0YYUlAJPRWO3HVDOD2QJf
	nYGtmMSUkee89pjYP14u3jXc4rtqlsDZkxRpX3xfgm7f5M419unxuSoMpN4bU/2b
	T+9JgB/T6JheG8GWZ4QrSn+VEoXln3q6iUT96JN0AltVjAsXNAWWnlp6XRQe+dk3
	FvJyU90TA23ylc5h5l//0fP4IEw==
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by m0089730.ppops.net (PPS) with ESMTPS id 40usnrra5s-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 13:40:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUFxVIX4DDW93LwOtTEbbP2azdwRST3SFjwiMSFapJ/SFdPDQrfT6Qp0w3tmMfH6zuPbrv7ca7xiVfL3zavJaZJRebj8qJ9fTdZK7Y1YGNjjtCqVjS373jBRcNUffRwxReodu95T7RBPoz7HefvrbTZOrlJuWaYfv84GkgzN9Snzq5DKbYbYBeSw6opKqmustCuzo521XauTEDWkh28e/Yt3pF3zOl/X7rTm5IHIbP1Uk27bgwsnPk3PFKVZAdhkvKBT0p8ffYW+CkyglhWDSm0/3IZDh+4WDyDj0ss0/89Oj4uD2eRbbz96G6xQulB3dTwEO7tXtyKM7voGV4e+eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+olge0+xEVI8skFdVFJ2XvuUKLZhG0sHvWipVaD5Bk=;
 b=VbKMJ+rFCJqb29ZZ2mcjDaIwJfFiRyH3esDpNpN3sKJ8voa4yQTZUyiN6GneY6xGWMFm/CUWSmtzzBEsdvgo8Q7Phy1RKpLJXHVtKGhJIGHnVpR+6yxCZEEcqTx0V8h227MZEr6P7ZitmRIYVVAWJ3PA0QAXAcXyBI58U8yPCYvEORDDem/TG0ncZ24Aha0pLaI6PAd+QO6GTrN5H0/D917Y7Zn1J26SoVRGiXayqFDzNCoV15mD/soLHhaSiP6NpO8Zfvnza7I09niGdz3WCWhMbmGraupWhv3rsM41TuJRxheUgNKI1RZzryK1W+TIdvjiFBmHYzH1c1AULm55Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by LV8PR15MB6634.namprd15.prod.outlook.com (2603:10b6:408:257::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Wed, 7 Aug
 2024 20:40:34 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 20:40:33 +0000
From: Song Liu <songliubraving@meta.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Song Liu <songliubraving@meta.com>,
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
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAKAOAIAAB6oAgAAI7AA=
Date: Wed, 7 Aug 2024 20:40:33 +0000
Message-ID: <A17155F6-1B57-4B25-BAB5-C03A59BBB8E3@fb.com>
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
In-Reply-To: <20240807160826.269f27f8@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|LV8PR15MB6634:EE_
x-ms-office365-filtering-correlation-id: 8aee5da1-3cbe-41d0-27c7-08dcb7212f27
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?WWVhWDZESjZQQm1LSW4zZVJTbG9aYlEyejNyZkxmMEk2QVljTkNzZXVoSENT?=
 =?utf-8?B?VGtDSGtjM3lQRXdsdFpRT0JBTHdvaWJ0b3liUGhMbVNKZ0hEanEyMWZmWjlE?=
 =?utf-8?B?aXU1Sk45RmtqcWZJWkJiMmppNzRGUEd5K004WHA3NEsrampHM3dQenNTb2dH?=
 =?utf-8?B?ckJFS09jUCswSHRvSlJwY3JKZUJHa3YrK0p5cjl1ZGJIZm9LTUUyU1VQY1pk?=
 =?utf-8?B?RThvODVOdkErWmZ4WWxHYXI1M3N3bEhjSnl1ZVUyRTg0Y0JURStvd1ltN0tR?=
 =?utf-8?B?cjMvb2VmZGw4MTQyeWJOWWljRC9wc2l0dTlJSmRrR1hadkIxTG9lMU1KdnhF?=
 =?utf-8?B?YWRWV0tnMjE5OWNWNEU2M3psK0k1cmpLZ3o4UEg2cjBEWU00eUJPanBOekxs?=
 =?utf-8?B?RFJOZElxemFhVzI2UzBLb1libzRCWXA3d2FIYVBmRk5rV0V3QVNYdlFVSzgw?=
 =?utf-8?B?ZXNGTXd6NUR5K093NnZIRURrdHVuYUlKdFNyOHB4K2c1bGh0aVdiYnl2aVFD?=
 =?utf-8?B?djBZbjFGL3ZJV3k0Y3Y0dU5uOFJEb1BJWDBHSUN1cDNJOUdZQzg3WDNHRjBw?=
 =?utf-8?B?S3I2WVg2MjJ4NjRJd3RFQ1p0RXhuYUtLNzd1TE83bWZZcUk1S0FpZkkrdFpU?=
 =?utf-8?B?UStucnd5dTcyWURPbkhMN1J5M21lUmNDMDhBKzc2RUgra3RneW1EQmZGQXdV?=
 =?utf-8?B?YUVoWlQ4SklwQ2dZS0RIcnptSFo5T082aDdnK3pXeUt3TEV2M2ZtOFZsWXBm?=
 =?utf-8?B?REtORURnZldsbEFjRmROK2ZTRnRaOHEzZEliT0JYb3ltRHIvMlA0YkV5aTdv?=
 =?utf-8?B?TXRkZ0hFUEZjUlZmYi9teU41RjlFZjZYeWRNUEswY0NMTCtxZGJnT05IZ05B?=
 =?utf-8?B?d2FWa1JMaFA3TlNEWmRWMTg1ZEV2MVAwTEw4MThZUDdIaS85RGxGY29NYU9m?=
 =?utf-8?B?RkRxVFpNckh6c1ZxSm9YOVJUQmxMTkdrTlJoWW9JR0N5MGYyckxUSVR1ZXk3?=
 =?utf-8?B?QllER0FHa2YrcHR0OVY0bGJxekJ5S3RLNXpMcU93SVB5QXhzb2o4UlNJU1Fv?=
 =?utf-8?B?azJIUXF0MDhtd2lRVEZocmE1amR1TFhkdlR2M3BPUmJnVUdBQm9QSlY2Um9v?=
 =?utf-8?B?dlpBTE9EdHJwMU5qR3BYY1ZRdGhvRVBhQ2Z3cnVtS1VQSEhwVG9SdUN1eUx5?=
 =?utf-8?B?M2g3V0dCUGtzK2ZZM3BXTWV0dzRRYU5FRTcwL0dmQWVHTnF1SlFLVUNXNnht?=
 =?utf-8?B?Y1luQWFyd1Bjcmoxa1FrSFdHcVo1cWNtQ2xCN0VPMURQVVRWYlUwRzdPSHZP?=
 =?utf-8?B?MVpGZU5KV3RoTTJvYWM2QUpUd0ROQVRzRGZ3amtUT2lQdDV6OXF0L2lGamlG?=
 =?utf-8?B?bFZvK0M5UGtnVm5jVVg4VHVIa0Q5ZnhrNCtGQ25lV3Z4ZDhVMS9LK1FOOXZv?=
 =?utf-8?B?dkpQSnM1UVpDaU9Rd1VML2ptclhxeFhLcEV4aDdSOWtpNVI3YkxrVTVSQTAx?=
 =?utf-8?B?Mi9odEVuSGZFVmd6YTlHVEs5TmRKZzV5L1JmVTJxQmtDemovbUhTUlF5YjJ3?=
 =?utf-8?B?WThLRFZJWkxHN1Bib3lUNUFmNEpMeTNmbDNhVldyTGYvd3BUay9KeExEb2pP?=
 =?utf-8?B?KysxTjErV0F5OCtiUFRRbzV5T2pWTXp1bVdTSlFqNnpCbC8yWGdnSWtkT25z?=
 =?utf-8?B?L2VyQ3Z4RFBKM1FCZ2I0RkxYSWZGRERtdk5FeENWWkxBRWppNDErNUdyYUpW?=
 =?utf-8?B?ekc5V1l5YkVydXdVZ3gyM21uMUphL3ArUDBQT1U5bWdsYXlqOU4wRmZoVnQz?=
 =?utf-8?B?VjFqRmp6dGNad1g5cHM0Qzh0a0hMRVB0ZUFUQ1czWDM3STQ0YzJJdGl2eWRW?=
 =?utf-8?B?YTFsUUkzYWVBdFVFemJuUWdSaGtabWp0ZUFPQTBuY0lFTHc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a1NUQlg3aURDWm54a1h2MW01cXZadEJzc0szT2xkaXFmR3plejIyY2NGRnIz?=
 =?utf-8?B?bTIwZmlrUzNiMUhrc1RxbGk0SWp5QW5aOGU4WjU3aUdPSDJwajBhK1JqcTha?=
 =?utf-8?B?TVZocS9iT0lubCtIalUvY3ZoWlFTQjFqZXRVSlhxazV2dDJqcnVyaTBzZGN5?=
 =?utf-8?B?Y1dLcE5naXo5UlZLZGRpTkF1QmZNOWZiVTFtcDZ0MnhHVTlmTnNkQ3Q4b24r?=
 =?utf-8?B?azN0a1ZFdWdLaHVGN0txS2xtVmpRTUUyWlBJUnFRWWcxMUtvSUlrYmN3NHhR?=
 =?utf-8?B?SWx1YjE4bnQxZTBMSzdNR0hmTXM0WDZ6enVHa1BJSUlPYkFJbXVWODV4NzRI?=
 =?utf-8?B?R0ZyUkZZZG4wZUd2R2o1TzN0VnQ4a2l6NmppSWdNYTNUcEgzVUY4TEw4VG1o?=
 =?utf-8?B?TWVzNUdseWFBakpLcVQ3ZGpaYkNTN2pYYTdYVmFPZzRtdW1mSWNDWGFaaUxX?=
 =?utf-8?B?OFcyWmNiR1UrUjhjUk1QZmprMzFVTU9oQWU1bjkvQWtvR2pxYTlvMGJEUTFY?=
 =?utf-8?B?b2E0Kzc5MG9XRzNyVE9ESXRZZlh0YlpYbXBML3pLUUpJbFNHdzhYWmg3TWxS?=
 =?utf-8?B?MDkzRWVYMXBkQmRScThyRDFCNUIybkhEUXE5N0JGNEcvQWQ5a2RmQTJHeDRH?=
 =?utf-8?B?bDFTalZSamxNR1BLZHZNZWw3cUNZdm5ENktoYUFxdkxtMUgrL3dmdWUrUU9z?=
 =?utf-8?B?Z3BEOXRZN2ZISDN6a1k5Z1hBYlljQitueTMzUTBYRXE5SFJaUWFqRXFHOWs4?=
 =?utf-8?B?YUsydzd6ekw2ai9CTFdvQXhVb3R3Y244RnIxQS9TcFd2ZndSaE0xRE9jNXVN?=
 =?utf-8?B?VDFqd2J0UGxReHJhWnBNVGNYczkrQnQranpsSFpQTlhqNlZPRHI5RUtaWVRy?=
 =?utf-8?B?TWxKcmc5bmR2V0xRaVZWV0dvdVMwTUlDcEY4VU9vdllGaUNWaURPRXZLbVly?=
 =?utf-8?B?ak5yaHFGdklwN05EQzk5UmREUHdtT2QvdVRRU1R1Z0t3QklUU3hEKzlYZnVE?=
 =?utf-8?B?UmdiWTVGWHpmWktESlhzTzMyb0tNdzNSdDRkZjdabjI3Z0pyNlYxL3pnVkcx?=
 =?utf-8?B?OVRtZ0dnNEo0ZEQydWFPWWppRlI3RGlSUVFseXYxTWZPUmU4Um5qaTBvVFJC?=
 =?utf-8?B?QUE2K1FqdXBNRi9WcHVkSHhqTHVXNG56V3ovaTMxWk8rZDB1THZvV043aE15?=
 =?utf-8?B?QVc4QldUOVNFMXAvQkRzUGxTMHlWZHp0K0Z5NGttdDZsSDEycTlLTnl6WEJO?=
 =?utf-8?B?cm5yaXpFZlNraHkzR05JUjdNN1V4QllSbDJudTZRUGkxbURBZVlJYktHT2lp?=
 =?utf-8?B?eTJQTlBPV0tha1BoZHdTZmptekY2U2ZRQmtRMXg1L2RQQjZxaDZZOXNidTV6?=
 =?utf-8?B?LzFVUGxiajJvVUZNZlE4eEdNdlZCYk1Mc1QyOTNCVCtFSy9kMU5JOEQ3a2lT?=
 =?utf-8?B?T2lCdWNCeXhnZytHdVhWUHM5dGxlOVJSWmRONTc1TkFmRXZyMy83bnZsTGov?=
 =?utf-8?B?SzVEbjYzOGdTd3FrUFFDbEpnbDZDOERoVFh6QmIwZ3QwKzRGUFdXaklQdmJw?=
 =?utf-8?B?T0QxYUlhTVRYRklJWGE2OWxoUlZVeDVKUUs0UkpmUGpvdmhGU1JtcGk3dmt3?=
 =?utf-8?B?T3FhcFZaOENKNjNNT2ZyamdZZjRTSytHbC8yaFZ2bjlxZS9xeWw3Z2w1N2JZ?=
 =?utf-8?B?MU1nRWswWFhxRksvWEdNQkZrOWs3UWRGVCs1UVFqVTBZOFgxVzNTYmNPWTNF?=
 =?utf-8?B?bDZycTU3SFFteGtFTmtYOVJvTlAyUmpmSnVlRkhIbk1zY2paZFNFVHJtRVpn?=
 =?utf-8?B?VjJyNkZnK2YwS1l1b2hJRkRxT29KTC9sNTNibVFyME9kQUZudDFRY09oZTRt?=
 =?utf-8?B?VGVYN0xMbmdhenBpSmUvTExrenBCenlJZzVqUEY5dXltWHMyUWJRSUxpSGtG?=
 =?utf-8?B?eS9kd1FhdWtkZE9RVTY4UUExWkc4VjdEalZUL2ZUakZ5MWZPS0c3NEo4MzFx?=
 =?utf-8?B?Wk15WUJZbXNrUGNQNDRiaGVRbk5uSkZQME9qdmJJRHZqckdNdlBXbHhqWFlN?=
 =?utf-8?B?NXprUkdpdDIzeklSYmk0U1lZcXV4R0xoUzlyM2tHS1JrTzVhLzhSRkpMS1c0?=
 =?utf-8?B?K2RWMWNuUkxLTGdDM1lhcmNRcnk2OVIrTVR4a2Vrb0FSSENVZ2JGMlF4SkRi?=
 =?utf-8?Q?jlnfLwpsCEG++SX6c63sXMw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F207EBADD0AC8648B7CE811A1EBFDEEA@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aee5da1-3cbe-41d0-27c7-08dcb7212f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 20:40:33.2470
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80UDG+DbQM3aGSktZ3B7gk4nnFdQnErwMxdWm9Osp36owW6vUcb03Y82wEE0/PzTqKCYhNPrXcR6VOpUy45e5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR15MB6634
X-Proofpoint-GUID: gjh93QOU8cEc8HkBReTcPF821QfBksMe
X-Proofpoint-ORIG-GUID: gjh93QOU8cEc8HkBReTcPF821QfBksMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDE6MDjigK9QTSwgU3RldmVuIFJvc3RlZHQgPHJvc3Rl
ZHRAZ29vZG1pcy5vcmc+IHdyb3RlOg0KPiANCj4gT24gV2VkLCA3IEF1ZyAyMDI0IDE5OjQxOjEx
ICswMDAwDQo+IFNvbmcgTGl1IDxzb25nbGl1YnJhdmluZ0BtZXRhLmNvbT4gd3JvdGU6DQo+IA0K
PiANCj4+IEl0IGFwcGVhcnMgdGhlcmUgYXJlIG11bHRpcGxlIEFQSXMgdGhhdCBtYXkgbmVlZCBj
aGFuZ2UuIEZvciBleGFtcGxlLCBvbiBnY2MNCj4+IGJ1aWx0IGtlcm5lbCwgL3N5cy9rZXJuZWwv
dHJhY2luZy9hdmFpbGFibGVfZmlsdGVyX2Z1bmN0aW9ucyBkb2VzIG5vdCBzaG93IA0KPj4gdGhl
IHN1ZmZpeDogDQo+PiANCj4+ICBbcm9vdEAobm9uZSldIyBncmVwIGNtb3NfaXJxX2VuYWJsZSAv
cHJvYy9rYWxsc3ltcw0KPj4gIGZmZmZmZmZmODFkYjU0NzAgdCBfX3BmeF9jbW9zX2lycV9lbmFi
bGUuY29uc3Rwcm9wLjANCj4+ICBmZmZmZmZmZjgxZGI1NDgwIHQgY21vc19pcnFfZW5hYmxlLmNv
bnN0cHJvcC4wDQo+PiAgZmZmZmZmZmY4MjJkZWM2ZSB0IGNtb3NfaXJxX2VuYWJsZS5jb25zdHBy
b3AuMC5jb2xkDQo+PiANCj4+ICBbcm9vdEAobm9uZSldIyBncmVwIGNtb3NfaXJxX2VuYWJsZSAv
c3lzL2tlcm5lbC90cmFjaW5nL2F2YWlsYWJsZV9maWx0ZXJfZnVuY3Rpb25zDQo+PiAgY21vc19p
cnFfZW5hYmxlDQo+IA0KPiBTdHJhbmdlLCBJIGRvbid0IHNlZSB0aGF0Og0KPiANCj4gIH4jIGdy
ZXAgY21vc19pcnFfZW5hYmxlIC9wcm9jL2thbGxzeW1zIA0KPiAgZmZmZmZmZmY4ZjRiMjUwMCB0
IF9fcGZ4X2Ntb3NfaXJxX2VuYWJsZS5jb25zdHByb3AuMA0KPiAgZmZmZmZmZmY4ZjRiMjUxMCB0
IGNtb3NfaXJxX2VuYWJsZS5jb25zdHByb3AuMA0KPiANCj4gIH4jIGdyZXAgY21vc19pcnFfZW5h
YmxlIC9zeXMva2VybmVsL3RyYWNpbmcvYXZhaWxhYmxlX2ZpbHRlcl9mdW5jdGlvbnMNCj4gIGNt
b3NfaXJxX2VuYWJsZS5jb25zdHByb3AuMA0KDQpBaCwgdGhpcyBpcyBjYXVzZWQgYnkgbXkgY2hh
bmdlLiBMZXQgbWUgZml4IHRoYXQgaW4gdGhlIG5leHQgdmVyc2lvbi4gDQoNClRoYW5rcywNClNv
bmcNCg0KDQo=

