Return-Path: <live-patching+bounces-431-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70976946250
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 19:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2191428373F
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 17:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1AA136335;
	Fri,  2 Aug 2024 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="b0QhmNZX"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0311916BE0C;
	Fri,  2 Aug 2024 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722618988; cv=fail; b=pRsV/vY/BCBYstq1SnTQ93SXw/TH6HF6sMj4zH7c5VCIpmcGbvD71JOskpDmfmZPeMn5m2J9K8QAK1ZJmXrH3SHXttUjMpd8zN03Qsapc/T8r8Oof0J+K2IUGy4kI7ALOqPUf1ahUXbhFKy08K2geZYMlFUXZ4GQkhelm9jild0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722618988; c=relaxed/simple;
	bh=nX7E4j0SUmstRNAm9PUJliKUkvaDl4t9dn+BUnUuqbI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JM+5W2rwN7z3yyXokftlb564/qw/MDRyshfTZ2++C54FdefSNBabAxw7XgOAEvHFkqVwWQ5+RSXvmIjIrN9CS0q2EgSUkQzUDkzutqzvkn2eUr6rrbI3Gs+6ikLMp38PByya1nPrphRxNWBnE51vdiIMo0viPNqoTMKD46Hl2mU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=b0QhmNZX; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 472BMYAE027847;
	Fri, 2 Aug 2024 10:16:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=nX7E4j0SUmstRNAm9PUJliKUkvaDl4t9dn+BUnUuqbI
	=; b=b0QhmNZX/rc1xOrJC4EfSl1fe7F+9BYVXma3L/LETQFEh1+nx43zmEa3A9I
	yEovXP/AhQ1n7kxFCB1E6VdqnDCEDdVNPKzC8VBWYBjHMHhtgPjUablmEYYa/QKA
	LJ5XKFPTcx4crMtkPkMV3vZz0QyYgqA6u3Ofs+Pu2EnQSEe3kNdvbp2bcqmfoKMs
	xyZNpBC2VOXNmK+A6uFDMIPUfoMpGrBZaYP6rgrKKszEaXAS6I1Kn91w18BZbYM4
	LkObgyqL21d88H79rbg7PpBx9TFifaISzbJehBPjkMw49Spg0pWv0bzsZE36c6EN
	ZzEcBzqZezQ3EsFj2a1QUUrh+CA==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40rjev64xy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Aug 2024 10:16:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EG1XLDIupkuVf2jLQUe9kl9qE4u7cPBKNelLR/1gnQCUkSUpv9+ZXxlzs0b/D/JM50Jer9Uzq/8EVTGLX4HRb9BUvoG+ljw++gbc0yZSiJfPnYgXcil0+usXVAOYBufgXLyllUUKAj4ZJNTuf61uJOocYIFJKzesESepusRcI0ChEUunM4p3EEK6VswB3dzTKAOW0Yu6H30vB5n5YZgbeZINvpSplQxoNUqnVvRSa40Wcq76lLtquetPLVRg0VxNUDxgCU6rk3hyop910bXZwPeWb2Riyj38duX/YINLNnBrD6FR1MoHKVeabMNWVy75eGsJRi8hUb9e8hHSZaD9pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nX7E4j0SUmstRNAm9PUJliKUkvaDl4t9dn+BUnUuqbI=;
 b=Q+T0EgV8IU1ezJfbUOEV7jmcoyx/2oM0iyUw8K2nDJQomAwHSoGhQVLDHItruIusEGNRgdooPxl79CaFCt0kd+0rQ358ZMRyB0LvzU9tGx8QEQb3ZpEvR3j0t17DdzhJxf+ndGZH+ZwCaUughrphCrlvzo+XTDBgRgqHqGI9vMvrxfecQQpdoggeQDmLQHuQGBCJeiyPlHJydbdeivD9E09fVAQxea7vfqYbYzVBMH+yoIuZNifb6dMp2D0tH+9IHQBLfekS0oHDYEISwHrrrXys9xNehTS8K8/JdZ3SlyxVSg7E8Y6fmBSn2eRQUFe7LUJxqS4YHRbslngZ78QFmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4351.namprd15.prod.outlook.com (2603:10b6:510:8d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Fri, 2 Aug
 2024 17:16:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Fri, 2 Aug 2024
 17:16:22 +0000
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
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Topic: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
Thread-Index: AQHa4hsdZBHaq1mnRkygDON43y0YhLIUOyIA
Date: Fri, 2 Aug 2024 17:16:22 +0000
Message-ID: <440AF603-49B0-435A-A59E-D5DDDD7BED88@fb.com>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
In-Reply-To: <20240730005433.3559731-3-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4351:EE_
x-ms-office365-filtering-correlation-id: 3d6a756b-49bd-4b09-6e43-08dcb316d53f
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cllKcW1GUFBTcXBTVXQya1JEdDNXRFA5czF3V1VoM0hJWHFnU1ZLelRNVkx1?=
 =?utf-8?B?ZnZQNXhseTB5TGh0YlRKMjBXd0EvQmZDRUx5NUUwdjVLVThReE5nSXBsNDR2?=
 =?utf-8?B?Smo5VGhab21UQVVYRlZpdzk2QzkxUVl5K3RvR0NSTG1yOXhrNnFzaWVSc3Yz?=
 =?utf-8?B?T1I1MHVJMk8wcHAwTjBIZzBNcndoWVNXdzBZWmJZTFU2SGVWUHNLWkRuUW14?=
 =?utf-8?B?THhYNWJzM3g0VEFpcDM2OVAxWjREclFlRFpYajRNb0RIeXY1SkhUdGw0ZkZn?=
 =?utf-8?B?cHlxNzRNT0ZTZ1hOV1lhaFhCQ3BSelJBTEQ1Y2dJckhsNE9IZVE1RzFzNHhr?=
 =?utf-8?B?ZU5UNFF2cUVJV1VSNlpBNDJLSmRtT3VSVVlGekF3SUFHZWQvYlNuVFJlWHpR?=
 =?utf-8?B?MUMvTldSdk1sOUxjSGxxd0xQdVdpSHM2S2FGWEtEOW9mOWNCSFZ5bTBHazRF?=
 =?utf-8?B?U29KUVFKR01JYUJKSWxlNnlrSG9LUndhSHdhbXZPdXlGRDBwYnQ1amZNQUt0?=
 =?utf-8?B?Wi9HR0hFSk14MzBFUzlqeEZuL2xobndnNVhLT0NLcTJMM3NVVUYxWFYwUEhP?=
 =?utf-8?B?THZHNE5qRnQyUm5INnBMQmlzQnZOcFlxTlU2MFh2bzdJbll4WmlFQ3RzVERT?=
 =?utf-8?B?cWFuZHpHblg5RWlPWTFhNW1IY29kQ3d0QUtEZFJ2SHVlVXUvbnY5Y25nY3BN?=
 =?utf-8?B?TTU3WnRHZjBjR0hWV1dWcWNoSGcvb3gyTEI3bU1Ud1QzemdyK3k4QUdDbHRN?=
 =?utf-8?B?YVRsanhaOTk2eUUrMS9WYUl0ZUI1cnlNM2FtWEJjR3pQbDFUNytGbnVqVkd3?=
 =?utf-8?B?N1V2THBsUVZ1WXhYdERROUxnTm85L0JqVDQybVlKcXVrcktQTUNaRUtRNU1u?=
 =?utf-8?B?UzRkcVByN0RkK2s5Rkd4SDcrcHFwbysrbFl2QSs1VUhYNDFUdFVCTHhkUzR4?=
 =?utf-8?B?K3BUKzdBWnYvcU9yaHprL01NOUdyU0k0RTliTTlSVFdoVWlWMUhIWVh5b3dp?=
 =?utf-8?B?RTBzc0VGOUJVZEhJcFJXSmI0WVlnVnJjNTBCYlk5MVdXNHFaU2NUV1pwdnhN?=
 =?utf-8?B?SS8rM3JwZXNROG16eUdQRzJuWTBPc2NrTENpUUt5UjNJbFNLa0c0QnZMczFl?=
 =?utf-8?B?S3IrVzlNR0E2ZXNQRW92NWYzbHgydFpGbXBvbFZiZURmQ1hRMi9wa2JBcFd2?=
 =?utf-8?B?ZHNmbXhEeC9RSkZseksxcWFKaDFMcXl4bENrb0VOVUtTL0hyN2JGVmQ4NFRT?=
 =?utf-8?B?ZmF2SmhnZjVSSk5DbW9uS0IvNUUzTENBNE96dHd5UHBUQ2U4bkN5NXZxNnhk?=
 =?utf-8?B?bHhudmxYYk94aVg0VG12clY3SHN5blMwanJteE9mVTVJQ1NyR08zVTB2WnJT?=
 =?utf-8?B?ZFAxSXBZMkNJZU9mcytwNWRYWGpwbjRPUEJXUUZqQXhyS05UZEIxOTVLaERu?=
 =?utf-8?B?c0FzY0xtR0gxUnZFTXZIekxHWkE2MnkzSmNIckdJaW1wS1hhQWkxVFNSVkJq?=
 =?utf-8?B?ZVZIRm1xejBwM3Q0TkIxQUpoN1JEb1FGZlEzclErT0xiQWNwYUM2bERCZ1px?=
 =?utf-8?B?WVdsaEF4ZEZKN0dKT09ETGtjcTBHUU1RRmlaNUg1RS9DdzlnZ1B6Zm1VdlJh?=
 =?utf-8?B?dlVyOXZaSEo3Y0R3dGFZMThKWVpUWFFRNHBWYzIxL0h1YjljbFZwZXlVb1Ez?=
 =?utf-8?B?aVUweXBySXVtdi80NkhUZUxJajhXTFlibkVuZ2RUdC9RZHNhWEc1ZjRDUXp0?=
 =?utf-8?B?TGRRckJxNXI5SlpvNCszQ2dXZ1NSR2kwU2VmTnMvNmZaVTZNQjBBNGt0SzY4?=
 =?utf-8?B?UmNURFI4TVpDOEYvZ3RQMTVDaEd4aWZFRWpkYnkwWnRrZ2NvTkI3bGI0RUJk?=
 =?utf-8?B?a3BLUmpvUEZ3Sy9TSVZPL1ZZbG5TTnlWMVVZdUpNTlBEY0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?ZlVmTjhkQUlvUUFYemlsT0dkTEp6WlowUlF1Ti9PbE13dU90ZTVwbG53TDJQ?=
 =?utf-8?B?MVN3RDVZQnhSOXl6QnMxVFczWHYvZ0tCOFZzMy8wa0JZRUxuelBsUko2QVFl?=
 =?utf-8?B?eStWQ1hNQjNZSExQcWVJUXlVOEhBMHBvaUhOR0c4MTFDcUhuY3lJd3JZWDFE?=
 =?utf-8?B?Yis0OU1zcWVHZnlLdG9zNDBPTm40ZXBJVExIMG90UENrbnVFVnc0S0xFUmpn?=
 =?utf-8?B?YW9TV0k0M1FsRG9nd1VzaXdhOE9wMkZhYjVoN01WdVErWjN0U040RTcxcXI2?=
 =?utf-8?B?RDdmVUJDSTQ2ZTNWSDYwMktGU1Bvdk9HdHJqMWtmdE1qaDRjWUJLN1BaUVM3?=
 =?utf-8?B?MW1OVjBXMjJyVWpUMjdNNk1FUWFyMlVlUDE1K0RzVWMvbDFCRlpBckJGQk5q?=
 =?utf-8?B?d0lzaGM0V0VUVmNRYXg4THl0aFpMdE0yRlhLUVNqNk5hRHY5Q3dvZXcxckdx?=
 =?utf-8?B?NzJuTHZad1ZPZlduVjFYUlUxbUNHdzQ0MGpVc2g1dVpyMHc1VlZUd1FEb2li?=
 =?utf-8?B?NDZBK0JhWXgzNmcwc2FERm1ESUU2aCtDcGE2czRmSTFLK29Nb3Iyd3BzQWlv?=
 =?utf-8?B?VUN6YmlZcUorNitNQXhsTWRLU0czc0Jjdnd4UXRtTm9RVHpMTlJwMVJBR0ZC?=
 =?utf-8?B?ZjhKZlVVZXpHamJyaFptT011VFMwbVFIaERjRGQvR1loZW11K3RJdnBxeHR6?=
 =?utf-8?B?UHMvZXMvVGR0Qnh6SU40cnFXTE9wcnVKY3pvL0ZyaUNiR3Y0RXFRL0RmTTg4?=
 =?utf-8?B?TDNLdm5VQ1dmSVFueXFOcmd0Q1liTXFVUEwwWkN5VDVIcmtSOXpxZHUrSWVT?=
 =?utf-8?B?N2thd1FCM0dhRXU5S016MGZoTDFNMUlnVUhSRi9YUVVUblZ0N3pWQTZqTGJ1?=
 =?utf-8?B?aWJyWURXb1RDcHQrM3lkTXRtTko5cGZ0ZzlQekQ5NkJRUkhZZzBRTG9GdjBi?=
 =?utf-8?B?UlJ4cE00Sjkyak5odlRTa3RaUWRiOEgybnF0VkllRHQ1NGl2N1VLK0xGck82?=
 =?utf-8?B?K1hsaGZ0Q2VUbVNiVzFtWlNINlVTTEdBK1pzeGdWSXNIK1h2TzdxMzhHdnRC?=
 =?utf-8?B?Uzk3ODVSbnBqRkJ3dkVHVU9GNHBVVVloRnRnYlhqNzhXTWEvbS9oYk82UUVE?=
 =?utf-8?B?cXhqVjFUaXJQYlNGT3ZjZFBDbFZLL2dQZEFMeGNUTVFrQTFHZWVka1I2YnM2?=
 =?utf-8?B?a29FakduV1JvMUJYQ1hEaGwra2hEQktJck5DVFg5YjNZa2tnOXUwaFpnTllI?=
 =?utf-8?B?L2VOWGtLTHA3eVdhenN0U1hpSncvdC9FcmR6cG1kdHJQR0VGUCtKZHh6QzNQ?=
 =?utf-8?B?NjVxSWIvdzJOZkxPWGhtbEdaWUgvZ2tBTWtOQlNHNWd1Q0dwSHFKSmxWZ090?=
 =?utf-8?B?WXltYmNocWQ3UTVscDFoaE80Y3BndFFnZ0RvRE42azBtcEEwYzFxdmRoZld3?=
 =?utf-8?B?UXBkZUVXL0FaSmM0THk4bXgwYTcyR1pHa1FkY3FscnIrQlFUdTlPaHdPc3JP?=
 =?utf-8?B?VUpRV3FONzRMc2Z5OU9Oc3o5S0lRNkF2cEU1ZmxvQ0grVWgxeW9EaC9XZGtR?=
 =?utf-8?B?dElQUVlwR0VoZGlDYUoyeTIveEpQbnJwcnFaY0M2Ynpsd1RKTkpxK2JYT0V3?=
 =?utf-8?B?MU1yR2ovM1hsWHdSWE52RHVWeXU1aUN3cDlzaVlQRCs3NlZGMFg1dlR6VEpM?=
 =?utf-8?B?dUpNcFlqeUpLdkVHQ3B0OU9rSjBMaHJPcDhzajFCYktQeHltbnJNSm4zVDZm?=
 =?utf-8?B?OUw0YzVzMFVUV0o4R2N5SnVZc3FOVTlxSEVud3Jjd0RNcFgxYXR4VXNaeXR4?=
 =?utf-8?B?UkpTL1N5L0xwdTRvQzNGNStlOHN4bjUrSjZFYW1DQzc2UnRTMTRMWTlCR1d2?=
 =?utf-8?B?K1h5MlV0SWlONzFtaXh2YzFYZ0J2d05QdktxOXhEZGJqMW5qbWltM0NnNUdN?=
 =?utf-8?B?ZzJSais0bllkSFJHb2tFSGJLRHhycG1PWW5pcS9TbnJCbGJuQzBvRzNEbTQy?=
 =?utf-8?B?QVJPZUpEMVpDRHp3M1lhVFYxd2NGc2xhODdUSVIrQWxhZ0tvMzNpRjNMdmYz?=
 =?utf-8?B?eDlsS1BaUVVqWW9TbStmakR5U0VtMTRhWkdmVXFpV2tXc3V4VlJrOUpQWU9t?=
 =?utf-8?B?ekdjNS9TNFhvRUhnQTQzdHpVRVNvODcyS0JNMkNTRFBtempFSnZMOW5xVGdZ?=
 =?utf-8?Q?X8Q/GwyKRaOjs3puo5Uyj7U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E1D8CDBF1E4BF4DBA922C46EC94E177@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6a756b-49bd-4b09-6e43-08dcb316d53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2024 17:16:22.7666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y6rY/XePgz9mV74pAO0kvos2PmhlST54V/0t04dkEfeWkPhOH8rC9VWUnhwUiaIlt6pfqBDC9/0koQzPuBLaQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4351
X-Proofpoint-GUID: eDzdLr0QHzxJUz0Y9NRro3q3R0FZwLzF
X-Proofpoint-ORIG-GUID: eDzdLr0QHzxJUz0Y9NRro3q3R0FZwLzF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-02_13,2024-08-02_01,2024-05-17_01

DQoNCj4gT24gSnVsIDI5LCAyMDI0LCBhdCA1OjU04oCvUE0sIFNvbmcgTGl1IDxzb25nQGtlcm5l
bC5vcmc+IHdyb3RlOg0KPiANCj4gV2l0aCBDT05GSUdfTFRPX0NMQU5HPXksIHRoZSBjb21waWxl
ciBtYXkgYWRkIHN1ZmZpeCB0byBmdW5jdGlvbiBuYW1lcw0KPiB0byBhdm9pZCBkdXBsaWNhdGlv
bi4gVGhpcyBjYXVzZXMgY29uZnVzaW9uIHdpdGggdXNlcnMgb2Yga2FsbHN5bXMuDQo+IE9uIG9u
ZSBoYW5kLCB1c2VycyBsaWtlIGxpdmVwYXRjaCBhcmUgcmVxdWlyZWQgdG8gbWF0Y2ggdGhlIHN5
bWJvbHMNCj4gZXhhY3RseS4gT24gdGhlIG90aGVyIGhhbmQsIHVzZXJzIGxpa2Uga3Byb2JlIHdv
dWxkIGxpa2UgdG8gbWF0Y2ggdG8NCj4gb3JpZ2luYWwgZnVuY3Rpb24gbmFtZXMuDQo+IA0KPiBT
b2x2ZSB0aGlzIGJ5IHNwbGl0dGluZyBrYWxsc3ltcyBBUElzLiBTcGVjaWZpY2FsbHksIGV4aXN0
aW5nIEFQSXMgbm93DQo+IHNob3VsZCBtYXRjaCB0aGUgc3ltYm9scyBleGFjdGx5LiBBZGQgdHdv
IEFQSXMgdGhhdCBtYXRjaGVzIHRoZSBmdWxsDQo+IHN5bWJvbCwgb3Igb25seSB0aGUgcGFydCB3
aXRob3V0IC5sbHZtLnN1ZmZpeC4gU3BlY2lmaWNhbGx5LCB0aGUgZm9sbG93aW5nDQo+IHR3byBB
UElzIGFyZSBhZGRlZDoNCj4gDQo+IDEuIGthbGxzeW1zX2xvb2t1cF9uYW1lX29yX3ByZWZpeCgp
DQo+IDIuIGthbGxzeW1zX29uX2VhY2hfbWF0Y2hfc3ltYm9sX29yX3ByZWZpeCgpDQo+IA0KPiBU
aGVzZSBBUElzIHdpbGwgYmUgdXNlZCBieSBrcHJvYmUuDQo+IA0KPiBBbHNvIGNsZWFudXAgc29t
ZSBjb2RlIGFuZCBhZGp1c3Qga2FsbHN5bXNfc2VsZnRlc3RzIGFjY29yZGluZ2x5Lg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogU29uZyBMaXUgPHNvbmdAa2VybmVsLm9yZz4NCg0KQWN0dWFsbHksIGlm
IHdlIG9ubHkgcmVtb3ZlIC5sbHZtLjxoYXNoPiBzdWZmaXgsIGJ1dCBrZWVwIG90aGVyIC5YWFgN
CnN1ZmZpeCwgdGhlICpfd2l0aG91dF9zdWZmeCBBUElzIHdpbGwgaGF2ZSB0aGUgc2FtZSBpc3N1
ZSBZb25naG9uZyANCnRyaWVkIHRvIGZpeCBpbiBjb21taXQgMzNmMDQ2N2ZlMDY5MzRkNWU0ZWE2
ZTI0Y2UyYjljNjVjZTYxOGUyNjogDQpiaW5hcnkgc2VhcmNoIHdpdGggc3ltYm9scyAtIC5sbHZt
LjxoYXNoPiBzdWZmaXggaXMgbm90IGNvcnJlY3QuIA0KKFBsZWFzZSBzZWUgdGhlIGNvbW1pdCBs
b2cgb2YgMzNmMDQ2N2ZlMDY5MzRkNWU0ZWE2ZTI0Y2UyYjljNjVjZTYxOGUyNiANCmZvciBtb3Jl
IGRldGFpbHMuKQ0KDQpJIGFtIHVwZGF0aW5nIHRoZSBjb2RlIHRvIHJlbW92ZSBhbGwgLlhYWCBz
dWZmaXguIFRoaXMgZGVzaWduIHdpbGwgDQpub3QgaGF2ZSB0aGlzIGlzc3VlLiANCg0KVGhhbmtz
LA0KU29uZw0KDQo=

