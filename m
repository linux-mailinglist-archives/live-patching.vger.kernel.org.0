Return-Path: <live-patching+bounces-469-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E38094C0A9
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 17:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD563B25F5B
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 15:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB88B18FC70;
	Thu,  8 Aug 2024 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WAmZqI/i"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104A018F2CF;
	Thu,  8 Aug 2024 15:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723129997; cv=fail; b=hgpN2h5mznic1H9bMw2amRDxqtzgC5qvJEQWeAbg6KhD6Ms7NOQTY/sHSMGnj2YwPxRzlSOYaPxvbcx3cFA1G1E45YdAzxnm+iyhSK6/s+EtRYq9hIepP9hI6wGGF5rL33kRiMPsF0Raphl6TNXCqqg3LO2qjOzNYvA7/GSGhqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723129997; c=relaxed/simple;
	bh=AfBiEdbC0QeYaP71u132tIUZnYsmBHBFcCMR6y8tL2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WDut5HSPWNw9ov6OPHYeEKTk5GF0ybc+U7YUMkrwwi08lRxj8L1drGTqnzSD6n86+6Q1ZmzBzESnFKU/q8DtXu498et/LgyCuyPepgvCLNbLj3HTI8bfSyP55+i5rAwsvPHdLCBNQEwq8iU7Z9gldRZCKOWx/J5nEqeRt/vK17o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WAmZqI/i; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478CqZx7012463;
	Thu, 8 Aug 2024 08:13:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=AfBiEdbC0QeYaP71u132tIUZnYsmBHBFcCMR6y8tL2E
	=; b=WAmZqI/irIgQNmkSwWkBTcc8tLV4fkGRKfccBHybNvLB/1kOxDOpyRLjKyS
	5h8Mo1wYrN2a9pM97/ydc7Cro0vg9pl5pemzLjq4AWlIyja5Io7qJxyp55cO5aJr
	mBoA/6iIXA7pLzmWxz/p4EqEnDCO/eXgXFrgdsCgL+NEEfb/tuPyzOs5SJtQTX6O
	RuiQGV13gupC3BRL35ogOYiVEQ4CQa/eaItwQEYuqI5ywhAlpNQWG71CiWgCScZz
	/f/1nnUHgbJ6ik+ZZOhtTP0KAX0CaA9n0eDrLAsuimIIwyrSUj7Ybfsm/uozgpoA
	pdRNpCGUTWmDa0oL2+oPINZsFjg==
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40vjducgcv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 08:13:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZAVx1h4kwvVfAMZCTQJ09hkue9eNzy7YFNVR90qc0H8DMmE2OBlMZeqkA4SqSlo9qDKsHuVa1TZI8b0j/r/JWljNUF2xcN8RVsAOI7MoESs79meNOKLbdim4n/uBWK+1PtkGWcOSECQnMgpKm8/HDudIFi5tz6buEjphfmjGkq2Oj2UplAz/3mSYEPXAIUkCbTXb0iXSqX/pIv7UFmaiMBj47lU+ARLbgvqIucZvPs94FD3YY/3duHqQaV6zi2phc6H2500J5+yeKazOOVDsydWO/R7ViGDZzHhwuxnmYd8/sCZnlyzBwm5EWF77F9hwwLEDaY3GupjVqeIvZG8VBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfBiEdbC0QeYaP71u132tIUZnYsmBHBFcCMR6y8tL2E=;
 b=uzgkHzvEpNM/s0waX0m1leErOihGXoADbWtTIGJLj+Bc/FSvicun1CDNU+YHrKokoptyf1OeaAxzg0bvyuzWOnOlW8kjDjyqQTsFhP6l/V27hPc7wmzuinMExsDkiBUKMQvs40LruGOokGAsgUSM0Un/v/8kpvQAn9QvBMNYEnnT4q/+DMtdFUEJNdtpHgS/q/6s4dwSXOVbnUi7+yRVS3BGJ88jQPYIlT4+uDy1+vVyK6ZaV1pSt+2qt/Wzw1xvIIYKB90kyMHmA6a1LkSe5PhHQ+sBL5XCAPHUsm3QVBmowDLeKvBg+9aIClYRFPA4KnW6H1lTpzxXfQ7hLk86hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA6PR15MB6539.namprd15.prod.outlook.com (2603:10b6:806:412::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Thu, 8 Aug
 2024 15:13:12 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7849.013; Thu, 8 Aug 2024
 15:13:12 +0000
From: Song Liu <songliubraving@meta.com>
To: Petr Mladek <pmladek@suse.com>
CC: Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>,
        Sami
 Tolvanen <samitolvanen@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 2/3] kallsyms: Add APIs to match symbol without .XXXX
 suffix.
Thread-Topic: [PATCH v2 2/3] kallsyms: Add APIs to match symbol without .XXXX
 suffix.
Thread-Index: AQHa5SA392cRe6GiQUK3ViY3gDHO+rIdLw2AgABRnYA=
Date: Thu, 8 Aug 2024 15:13:11 +0000
Message-ID: <46BBACAC-4C47-4558-A228-74BF55F8EC92@fb.com>
References: <20240802210836.2210140-1-song@kernel.org>
 <20240802210836.2210140-3-song@kernel.org> <ZrScBzRRTB--q7Y-@pathway.suse.cz>
In-Reply-To: <ZrScBzRRTB--q7Y-@pathway.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA6PR15MB6539:EE_
x-ms-office365-filtering-correlation-id: 9df67d17-81dc-4e4d-6b45-08dcb7bc9e7b
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?L2tubEZ4RGtoS3N5Ymx6N3orRVFTbGx0d0pHQ1MrTWxVcUtzNjlvazRQUVE5?=
 =?utf-8?B?RGRXUThxbHlwZm9lZmtJd2RrK2VUdExuQ3I5SWovWjBza1dWK2psOTk1UGhx?=
 =?utf-8?B?SURIRTNwWXRKVUtYU0hTQ1RLUzNaNmFSblpvUC9JY1BDa1g0eFBEaElPalhs?=
 =?utf-8?B?Y0MvM2IxYXUvaXB4eUtneGRLOHo5YlYwbTJHZDM4WUl5blg5R1dMd3lYK2V4?=
 =?utf-8?B?TS96ZFJjb3ZmcUZmaWF3NXFKUkdvUVhZWXJ0VmNvaVRjcmRvRGJIeFJCdjNE?=
 =?utf-8?B?YklEc0JPZFgyOCtSSEJBaURpYjBaRW16QWN0c2NtUlBLUHJDY3puSUVEejFN?=
 =?utf-8?B?ckRUV1piM3htMU1tLzR6RGt6b2lyK0tiRk92TEM5dHpBUjBnbGtYTk9oSW1M?=
 =?utf-8?B?RUJvcyt4T05QbWo0RWd6YjNJOEZYN3BueXBPUXNpc3RhVEJrd2p2MFNBaWUw?=
 =?utf-8?B?WDMvYlpvRzdwYjdtSFNjbis0NG42bzBLbXlaRGttYW9nd3lUNllrdGcvUWE3?=
 =?utf-8?B?cE5RV2paM3R5Q2o4dHl5bWZBRUQ5RERtUWkycWxlTUxpenBId1kzSU5FTXpI?=
 =?utf-8?B?MmRZMnlmcE1mQS81L2pldGtKRmZ6U29GZjBFWTR0YzNqeTlGakRDSTZlK1hy?=
 =?utf-8?B?bEQxdFdpS09RN2E2eDRTQ2hzSjViYTRjNHZZN0I1cnJuME16VGZTL2Y0RFo3?=
 =?utf-8?B?WEpKQk12M29WQkc5VGJ6V0h6M2JnSmJOZEpGbExIZWs2QjBCMXpwQ0hxMjI4?=
 =?utf-8?B?NkxWWHAzRS9EdVdsQ28xNGFIMTFPWW5hZmNYeGoyN0RuN2VyTVNvdWxmQXl4?=
 =?utf-8?B?OXNJaHd0a0o4cUlhOHZUYWJ0bGVwUy9HOUhVOXFGYVlrNlJSNTFZTG5yd3hN?=
 =?utf-8?B?bkZTMDVaQ2NZOGpHTTdjRVNmc2puaTA3ZjB6MG5YYU1mMldWd2tkK1ZucTRx?=
 =?utf-8?B?WmpOVGJKUmtUNjlyWWZXSGhuZXVKR2pzOHJWWTkxVmVieDJVbE9HWjFHbDh1?=
 =?utf-8?B?OXl4eVZKQnhhWjNwdGZ2K3NtR3ZscndIanpmZ1BDMXQyYnBCSXRHUnRtdFMv?=
 =?utf-8?B?eDJFYTNkTXVyTnptQWZwSCtsS1N5akFLcUpFY0dvb2JwUlBZS2R1S3FjUFo2?=
 =?utf-8?B?dWRoTkY1c2xBSnpuTlE1UVFoOWdkbFR1OWR6V2RGNi9yNnpzd1djajYyL0hz?=
 =?utf-8?B?Zzh6emF1YVUvU3BsTmdIWjhKK1V3MkZtNFprQllrbWFoMTNWUHpZY0I4SWc1?=
 =?utf-8?B?RlV0VzFJdFdvWmo5UkJjTkJHQ0s1eFpIZkxyN1czanE0SGhmT0dVY2R4MGp3?=
 =?utf-8?B?ajRRa3RVQmZnd3ZCWFhubk44K0NWTEYwbndLSDhoSjg5ZC93aklsYUtzWmFR?=
 =?utf-8?B?Y0UzTTdtbW04OUdCVFpNek5QbnhqeTNKT1F4SHZ1RDdkak5MU21wdHpGZFJ3?=
 =?utf-8?B?K3I1cjd3dmd3V3RGTW4zQ1ZaMjlzWDkyaWlaLzNlWFhCMzlhMmhJOFFOVXRP?=
 =?utf-8?B?azRMZTI4dnVhd2dHNFc0QXVtaklUY0dNVVU3VmpRKzZCQUIrMUFZeHhvZTE0?=
 =?utf-8?B?WGwvSnAvRDlKTjFkSUJjV2pCM0xxcHZSVVdJdXB3S3BuSXh5RnFaVHdGOE9q?=
 =?utf-8?B?MlZNVTRCaG1mU2NpQWwrby9lSHNtRGRVUUorb0g1c0prU2t1RlB1WlpyUzRW?=
 =?utf-8?B?WEFyU3JpMHcwTk8wUUx4Y2h1UlkyeFRWelBDdXQ2TS9SVlNMdkRPNkk3OW1E?=
 =?utf-8?B?bFJUODRWb2lKT1VEUGtxYW9tOFZvSThjNU9zSExaVUhkaU1ldEZZYWY5aEE3?=
 =?utf-8?B?bDRUU0l3K0QyUTV1cVpqbDFNOFI2dUhEOHl1ZVRNQmkvUkpQcVN0V0JGQUl4?=
 =?utf-8?B?SDhNMWhsNzhkR0Z6K1VWSGlRZHA2QlNuN1g0T2tnQktZaUE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?bnUwTUtKbWE5UkcwVnJjOGdFZFJaWEROV1M4aEZOdEJJa3RhcU1jUWk1THdU?=
 =?utf-8?B?N1FNTDdWV2tVbkhRdFA1TjRCMm9xWlkrM01KNStlOS9aM2ZGUU5Nc0ViVXlI?=
 =?utf-8?B?eVNSYi85SzFFWWx5ZExkV01DS3ZacWJ4TVdXdXFIOGRyakpKSnNSSVRHc285?=
 =?utf-8?B?UDRZcE1SUmcydnRud1FCaEdXb3h1MTBFZmxYbUtPREVEazZNM3pIaXNiZE9p?=
 =?utf-8?B?eGt4Yk5GK0wzeVVBaVV0aVBYTXRZczNSeUdQa3I3bzdxaHV1QkhqTTAwOXNV?=
 =?utf-8?B?RVRlcE91SHhwMEQzRGtXUGEyMHdRYjNHTlZyWGdYNHRYUERoLzZEQXRvbTVV?=
 =?utf-8?B?aTRMZEdYL2E4emlxbkRWOVQ0SlFSbGJiRi9LOXRFV2wvdW5Oc0Q5Z0h1M0ly?=
 =?utf-8?B?WUhqaXhReHlJY0IzUXNyMmFEYWR4OXpyTUtzVE01RDF0V2JQKzFjY3ByeXJJ?=
 =?utf-8?B?WUZmc1FEQnFRUTRiY0tGMmk0NklzV09hOER2ME1ZNDcxOThYSmJjVU5uZEhR?=
 =?utf-8?B?UkpIUmpablJSQzRvU2MrcEd2QmVlQUVzd2N2ejJIWjhRaGhkcjhpVm1ZT3RQ?=
 =?utf-8?B?dWdweTJ1SUVDTHBRMnJHeitDTTV2WDVFbGZoRFF1b0JYOTB5RUtCaWZra243?=
 =?utf-8?B?WTZiUURJQTN1QzN1RUQ5Nm8rVElrMnRJR0J6UUl3b3AycXJsdUhCN3Mrb1VX?=
 =?utf-8?B?aHFYNkdCRFdKdVFSLzNrRXZFREpIb01wdSt6ZkVhU0hwTzJKNDdxL2FqWFo3?=
 =?utf-8?B?SDdUT29HNXhBSEEvN2grZzBKb2pZdjFVT1F6YXBZY3hBb3NQUXBHUHNIb0Vz?=
 =?utf-8?B?OXVBYlFucG10ZFNRM2JwRUczMmRlUlFZNWhMd1Uvb3NkeGtwcmVPZGJ5RnFI?=
 =?utf-8?B?N3FKNTVSOS8wQ1h4TVFiSWtzNmxtK0dSRGVCQmdBR1Q4ZEtDa1RySmFoN0Y4?=
 =?utf-8?B?OFlUY0ZYdHRyU0pzTDZqTk94QXZQVTJPMkhTaERWaTFNdVhyVmYrMGt2UXJQ?=
 =?utf-8?B?T1JsVzlsQ1NvdzhsU3JuMkVSVGxpZ1Vubk5helM3VXJRV3RNdEhYcjNKNVZN?=
 =?utf-8?B?Y2xwT0hRdXBFczYrUFhjVll0VnIycE92RVVSWkprNE1VSTJVM2VHNzd3U25x?=
 =?utf-8?B?Qzk5QTZzdStFZ1ZkREM2L1Fra1pyNFVSQnFDeUtzK1A4NVhodzMwZ1NhVjVB?=
 =?utf-8?B?bzd5TlpENmdud2t2b1Q3UG1QbWY3NzVRbE54QmEwWXl3SkVpbWlvcWlaTk10?=
 =?utf-8?B?RHJJdytVajE1WURXS2JkS1dybjI3T2ZtOG1qQVVxNHhJWXM5bnpJVllaSVJS?=
 =?utf-8?B?cE5FUk9wL2hOaTVIdEJQZGRMNEdGYll1bkYyMGtubVliVTdRS1dpNFlMMnFI?=
 =?utf-8?B?V0IwOGc4dXRsSWJDZjZiRkNlWVdJU2xsaEVhTCtCRE5UaTNLUmtYUW44SkI2?=
 =?utf-8?B?RHBORVEyTVhSYSt1cmVtbWJjY0NGeHREK3VlVUVkTE45WFByRk9seHV3OU9y?=
 =?utf-8?B?d05kMkhnVEV3eEFheXdvQ0k3MDZ6aFlQQmhSMlRIMEZsdStOdS9TNGRpN3VZ?=
 =?utf-8?B?dG1LUU54ejhFMHhEdHhWKzZ6SXdxN1lYeEJyUkFqMGJkSWI3TnFpbU91Zk96?=
 =?utf-8?B?WVNJZllOdVRRancyN1RHMGtNdnpQMVBKdjMzZ1FLMXpyWURoaVhhWi9SK1dV?=
 =?utf-8?B?SzNzd3I2Z0Rua0ZmUld6RGdhalZjdTZwQ1JvQ0hVZUxKczliWkFkOWtkcGE5?=
 =?utf-8?B?WFpmQzRmTTh1Q2VLdDJEeEU4WS9JVnY0OHhlSjVZZEMxd1c3SmY4NUJRNU15?=
 =?utf-8?B?bVZUUXpNdndPQkJIRzlhQVROUGNzdFNvYXR3bUJUckpiVXpneGV5ajhKQVU4?=
 =?utf-8?B?NGx1MjJveU1TU0svQksvclJzU0owcW45NkozbTJtbnFxT0d3ZjBoL3orT0dR?=
 =?utf-8?B?Q1p2WUFrWHJoamVBQmRkZTRGNHg3bHRid3dObnZsM2hTcUg2cnNObTFZcm5O?=
 =?utf-8?B?Y0Y4bVBXSUJ1My9oZGdxMG1adGE3RnFBa24vclRGMzZLSWtWNHNkOUgva2tr?=
 =?utf-8?B?R1Q4NCtCdCtIMVdFWlh0TGxla21uQjhOeTVNU0lDbVZVMjZ6aHdPL2pvTEVz?=
 =?utf-8?B?YmV0eC9uVHRza0E0K3B1Ylova0JKMVd4dUxUeWVxcWNueHd5YVRZQStMNUkw?=
 =?utf-8?B?b2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCCCEEADBE014E499DA9C748CE40A801@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df67d17-81dc-4e4d-6b45-08dcb7bc9e7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 15:13:11.9864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CWfPhwhRtgiEv00kl4nZEpX2869qCeN9Q5xy9Oyd7Lb42TiwRqWjQjn4ycBvsMFVwGsEMFUjXNsFjQr5Ohy0/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR15MB6539
X-Proofpoint-GUID: bO74rebjKd04tUCBCR3OApDlSIZ6IHrg
X-Proofpoint-ORIG-GUID: bO74rebjKd04tUCBCR3OApDlSIZ6IHrg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDgsIDIwMjQsIGF0IDM6MjDigK9BTSwgUGV0ciBNbGFkZWsgPHBtbGFkZWtA
c3VzZS5jb20+IHdyb3RlOg0KPiANCj4gT24gRnJpIDIwMjQtMDgtMDIgMTQ6MDg6MzQsIFNvbmcg
TGl1IHdyb3RlOg0KPj4gV2l0aCBDT05GSUdfTFRPX0NMQU5HPXksIHRoZSBjb21waWxlciBtYXkg
YWRkIHN1ZmZpeCB0byBmdW5jdGlvbiBuYW1lcw0KPj4gdG8gYXZvaWQgZHVwbGljYXRpb24uIFRo
aXMgY2F1c2VzIGNvbmZ1c2lvbiB3aXRoIHVzZXJzIG9mIGthbGxzeW1zLg0KPj4gT24gb25lIGhh
bmQsIHVzZXJzIGxpa2UgbGl2ZXBhdGNoIGFyZSByZXF1aXJlZCB0byBtYXRjaCB0aGUgc3ltYm9s
cw0KPj4gZXhhY3RseS4gT24gdGhlIG90aGVyIGhhbmQsIHVzZXJzIGxpa2Uga3Byb2JlIHdvdWxk
IGxpa2UgdG8gbWF0Y2ggdG8NCj4+IG9yaWdpbmFsIGZ1bmN0aW9uIG5hbWVzLg0KPj4gDQo+PiBT
b2x2ZSB0aGlzIGJ5IHNwbGl0dGluZyBrYWxsc3ltcyBBUElzLiBTcGVjaWZpY2FsbHksIGV4aXN0
aW5nIEFQSXMgbm93DQo+PiBzaG91bGQgbWF0Y2ggdGhlIHN5bWJvbHMgZXhhY3RseS4gQWRkIHR3
byBBUElzIHRoYXQgbWF0Y2ggb25seSB0aGUgcGFydA0KPj4gd2l0aG91dCAuWFhYWCBzdWZmaXgu
IFNwZWNpZmljYWxseSwgdGhlIGZvbGxvd2luZyB0d28gQVBJcyBhcmUgYWRkZWQuDQo+PiANCj4+
IDEuIGthbGxzeW1zX2xvb2t1cF9uYW1lX3dpdGhvdXRfc3VmZml4KCkNCj4+IDIuIGthbGxzeW1z
X29uX2VhY2hfbWF0Y2hfc3ltYm9sX3dpdGhvdXRfc3VmZml4KCkNCj4+IA0KPj4gVGhlc2UgQVBJ
cyB3aWxsIGJlIHVzZWQgYnkga3Byb2JlLg0KPj4gDQo+PiBBbHNvIGNsZWFudXAgc29tZSBjb2Rl
IGFuZCB1cGRhdGUga2FsbHN5bXNfc2VsZnRlc3RzIGFjY29yZGluZ2x5Lg0KPj4gDQo+PiAtLS0g
YS9rZXJuZWwva2FsbHN5bXMuYw0KPj4gKysrIGIva2VybmVsL2thbGxzeW1zLmMNCj4+IEBAIC0x
NjQsMzAgKzE2NCwyNyBAQCBzdGF0aWMgdm9pZCBjbGVhbnVwX3N5bWJvbF9uYW1lKGNoYXIgKnMp
DQo+PiB7DQo+PiBjaGFyICpyZXM7DQo+PiANCj4+IC0gaWYgKCFJU19FTkFCTEVEKENPTkZJR19M
VE9fQ0xBTkcpKQ0KPj4gLSByZXR1cm47DQo+PiAtDQo+PiAvKg0KPj4gKiBMTFZNIGFwcGVuZHMg
dmFyaW91cyBzdWZmaXhlcyBmb3IgbG9jYWwgZnVuY3Rpb25zIGFuZCB2YXJpYWJsZXMgdGhhdA0K
Pj4gKiBtdXN0IGJlIHByb21vdGVkIHRvIGdsb2JhbCBzY29wZSBhcyBwYXJ0IG9mIExUTy4gIFRo
aXMgY2FuIGJyZWFrDQo+PiAqIGhvb2tpbmcgb2Ygc3RhdGljIGZ1bmN0aW9ucyB3aXRoIGtwcm9i
ZXMuICcuJyBpcyBub3QgYSB2YWxpZA0KPj4gLSAqIGNoYXJhY3RlciBpbiBhbiBpZGVudGlmaWVy
IGluIEMuIFN1ZmZpeGVzIG9ubHkgaW4gTExWTSBMVE8gb2JzZXJ2ZWQ6DQo+PiAtICogLSBmb28u
bGx2bS5bMC05YS1mXSsNCj4+ICsgKiBjaGFyYWN0ZXIgaW4gYW4gaWRlbnRpZmllciBpbiBDLCBz
byB3ZSBjYW4ganVzdCByZW1vdmUgdGhlDQo+PiArICogc3VmZml4Lg0KPj4gKi8NCj4+IC0gcmVz
ID0gc3Ryc3RyKHMsICIubGx2bS4iKTsNCj4+ICsgcmVzID0gc3Ryc3RyKHMsICIuIik7DQo+IA0K
PiBJTUhPLCB3ZSBzaG91bGQgbm90IHJlbW92ZSB0aGUgc3VmZml4ZXMgbGlrZSAuY29uc3Rwcm9w
KiwgLnBhcnQqLA0KPiAuaXNyYSouIFRoZXkgaW1wbGVtZW50IGEgc3BlY2lhbCBvcHRpbWl6ZWQg
dmFyaWFudCBvZiB0aGUgZnVuY3Rpb24uDQo+IEl0IGlzIG5vdCBsb25nZXIgdGhlIG9yaWdpbmFs
IGZ1bGwtZmVhdHVyZWQgb25lLg0KPiANCj4+IGlmIChyZXMpDQo+PiAqcmVzID0gJ1wwJzsNCj4+
IA0KPj4gcmV0dXJuOw0KPj4gfQ0KPj4gDQo+PiAtc3RhdGljIGludCBjb21wYXJlX3N5bWJvbF9u
YW1lKGNvbnN0IGNoYXIgKm5hbWUsIGNoYXIgKm5hbWVidWYpDQo+PiArc3RhdGljIGludCBjb21w
YXJlX3N5bWJvbF9uYW1lKGNvbnN0IGNoYXIgKm5hbWUsIGNoYXIgKm5hbWVidWYsIGJvb2wgZXhh
Y3RfbWF0Y2gpDQo+PiB7DQo+PiAtIC8qIFRoZSBrYWxsc3ltc19zZXFzX29mX25hbWVzIGlzIHNv
cnRlZCBiYXNlZCBvbiBuYW1lcyBhZnRlcg0KPj4gLSAqIGNsZWFudXBfc3ltYm9sX25hbWUoKSAo
c2VlIHNjcmlwdHMva2FsbHN5bXMuYykgaWYgY2xhbmcgbHRvIGlzIGVuYWJsZWQuDQo+PiAtICog
VG8gZW5zdXJlIGNvcnJlY3QgYmlzZWN0aW9uIGluIGthbGxzeW1zX2xvb2t1cF9uYW1lcygpLCBk
bw0KPj4gLSAqIGNsZWFudXBfc3ltYm9sX25hbWUobmFtZWJ1ZikgYmVmb3JlIGNvbXBhcmluZyBu
YW1lIGFuZCBuYW1lYnVmLg0KPj4gLSAqLw0KPj4gKyBpbnQgcmV0ID0gc3RyY21wKG5hbWUsIG5h
bWVidWYpOw0KPj4gKw0KPj4gKyBpZiAoZXhhY3RfbWF0Y2ggfHwgIXJldCkNCj4+ICsgcmV0dXJu
IHJldDsNCj4+ICsNCj4+IGNsZWFudXBfc3ltYm9sX25hbWUobmFtZWJ1Zik7DQo+PiByZXR1cm4g
c3RyY21wKG5hbWUsIG5hbWVidWYpOw0KPj4gfQ0KPj4gQEAgLTIwNCwxMyArMjAxLDE3IEBAIHN0
YXRpYyB1bnNpZ25lZCBpbnQgZ2V0X3N5bWJvbF9zZXEoaW50IGluZGV4KQ0KPj4gDQo+PiBzdGF0
aWMgaW50IGthbGxzeW1zX2xvb2t1cF9uYW1lcyhjb25zdCBjaGFyICpuYW1lLA0KPj4gdW5zaWdu
ZWQgaW50ICpzdGFydCwNCj4+IC0gdW5zaWduZWQgaW50ICplbmQpDQo+PiArIHVuc2lnbmVkIGlu
dCAqZW5kLA0KPj4gKyBib29sIGV4YWN0X21hdGNoKQ0KPj4gew0KPj4gaW50IHJldDsNCj4+IGlu
dCBsb3csIG1pZCwgaGlnaDsNCj4+IHVuc2lnbmVkIGludCBzZXEsIG9mZjsNCj4+IGNoYXIgbmFt
ZWJ1ZltLU1lNX05BTUVfTEVOXTsNCj4+IA0KPj4gKyBpZiAoIUlTX0VOQUJMRUQoQ09ORklHX0xU
T19DTEFORykpDQo+PiArIGV4YWN0X21hdGNoID0gdHJ1ZTsNCj4gDQo+IElNSE8sIHRoaXMgaXMg
dmVyeSBhIGJhZCBkZXNpZ24uIEl0IGNhdXNlcyB0aGF0DQo+IA0KPiAgICAga2FsbHN5bXNfb25f
ZWFjaF9tYXRjaF9zeW1ib2xfd2l0aG91dF9zdWZmaXgoLCwsIGZhbHNlKTsNCj4gDQo+IGRvZXMg
bm90IGxvbmdlciB3b3JrIGFzIGV4cGVjdGVkLiBJdCBjcmVhdGVzIGEgaGFyZCB0byBtYWludGFp
bg0KPiBjb2RlLiBUaGUgY29kZSBkb2VzIG5vdCBkbyB3aGF0IGl0IGxvb2tzIGxpa2UuDQoNCklu
ZGVlZC4gSXQgYWN0dWFsbHkgY2F1c2VkIGlzc3VlIHdpdGggR0NDLWJ1aWx0IGtlcm5lbCBpbiBt
eSANCnRlc3RzIGFmdGVyIHN1Ym1pdHRpbmcgdjIuIA0KDQpUaGFua3MsDQpTb25nDQoNCg==

