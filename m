Return-Path: <live-patching+bounces-1835-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B91D3C5057C
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 03:26:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E3EC189151E
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 02:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E7F81FDA92;
	Wed, 12 Nov 2025 02:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="NG7Qq0U+"
X-Original-To: live-patching@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazolkn19012020.outbound.protection.outlook.com [52.103.11.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB0335CBA1;
	Wed, 12 Nov 2025 02:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.11.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762914385; cv=fail; b=EktGxv+/y2QzS3KnSuJNb+O9p3vwFZUaLChkrjaPYxBErD/nGbKvAXk5mp7ZfqeyMbCkP8FgWhXfo+DYZ/awKnePsuAORu+GdNxHEw8yWSZEFms0jOvJhiwQ9/Mcp5T8OsU1OVQDJWvQYG38dhX5tUrPG0xnrtdL/e4rRiV1vIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762914385; c=relaxed/simple;
	bh=0X2PV/27n2CSR5KujbGaxmR+CKDW/OStWIUePiO0uZ4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pk1rxGKf3e6Up8xYc8wb/1SQVaqwHT1Te4j96EswB5jrOHl32cwba8EGr7RQ3cuZykHUO+C61oKXE271c/xgAAloY5t5tAIcgAMtLSeMJKdZD23+gQHpMuJdy1uYibPTF+MLsSLt0n0gxYd39WyYO3qqBOMnDiDwpm0tFk1xoxM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=NG7Qq0U+; arc=fail smtp.client-ip=52.103.11.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MA8zkihvChZlYwvle9pVqpJ2tR3mZQKNyReoM4lmcS+vDC4MOEumC5V3PpK6pHWes2ey7DoEKUTTlyFide7sGwBSrv7+D6MvFLtpUmpE5IF9sBGUz9hcuuYNOqYTpsN867X6IhVC0fkb+r1R4ATXodZCkf9NJh3dzMPK+xfYHRDVq6sct/WCe969BvNeKHUkpG8Aib3dsTXPHFWw7rwF5vz0svTw+wSKZNZSOvkVZx6gk+/LtD4+wGY6vHU8LJxABsP4sfBSQUqiBZrOJKYtMp/GsympQT1N4XhDJP8MEdVnrftvO/TzIbudaXdVoqJuEvQ376vtAQaOctmIXeef+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0X2PV/27n2CSR5KujbGaxmR+CKDW/OStWIUePiO0uZ4=;
 b=OWyjrVIGocBH/c9eyNNfs2LEY1MIm+7rRG/qeZiL2TBjK8RuOglpvdtLiyDa2ce0F/HXFjdOXM5WDaInhVVkWpELiLmQnIVMIdAJ3wFdz+wWzEzDVZVvG5//Yz2fWuwlMX3ZtchZIt7d2gLDyIGDxDqeD+c46YR85p3JZ1FZVk2jmt3WCplHHY82ePyiwmWlhuvWetsJTv3Z+obkQb9CupWuJCbfWqce45k8nedH/id67+YbJCrOlKKmonyf4qeykm7grfkWnNiC/dzO4NxO7foazFQ42JNQjHYi5u4/SGIxmdNCsh0KEvOTiMEpQn/86OAfKegYEK8QBqvwgDI7HQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0X2PV/27n2CSR5KujbGaxmR+CKDW/OStWIUePiO0uZ4=;
 b=NG7Qq0U+OU8K9kH8z+Tj+1Yrd0XvL+LUawN827QN2pAP4VsL5S/jIHW2fTAVWvD+02i9+aFg1by3Ffo0vE9bta1NvSwczkWkb5DJwgvlFgcdhUFiGSTnH9tJUVsWf3yPLve/OSao8RMq1+yemZqBFvcMkFdVIyYUi+VChTqkU4lpLlCaSdzY8F8qzZw4dYuytt2d8lOadvHJLbta2c8z5Ze79S45anuJm1XXJU3jpODEOeDazoRq2ghC74Ra/jWaI8QQhNkISLz+Ejl5ww2HIuc2hT3ykvNz9GHKuoTX+NyvW4T1q/aDE1+UfzqJkZ1J2oqZ3Y8FPheioj2PlVLNOQ==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by DS0PR02MB9102.namprd02.prod.outlook.com (2603:10b6:8:132::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 02:26:18 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 02:26:18 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Michael Kelley <mhklinux@outlook.com>, Josh Poimboeuf
	<jpoimboe@kernel.org>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Petr Mladek <pmladek@suse.com>, Miroslav
 Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>, Song Liu
	<song@kernel.org>, laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin
	<chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>, Dylan Hatch
	<dylanbhatch@google.com>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Topic: [PATCH v4 49/63] objtool/klp: Add --checksum option to generate
 per-function checksums
Thread-Index:
 AQHcJ+6qpEmfJskj+02bf6oIo51EqLTUFK6ggAK7zwCAAjZrQIAVN1sAgABS88CAABWQMA==
Date: Wed, 12 Nov 2025 02:26:18 +0000
Message-ID:
 <SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
 <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
In-Reply-To:
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|DS0PR02MB9102:EE_
x-ms-office365-filtering-correlation-id: 0b7f6b6b-4572-4390-6225-08de2192dc99
x-ms-exchange-slblob-mailprops:
 WaIXnCbdHrNsJbj7NxvUrpSYkT7K1zyUu3suhFt4KDvPuJyFtiCSU0pqy6e64MxE4zDyG9bzRsE25eRenLDnuu2TRPGODe83Qp0SH3+yzyuazdD1Yk8/aQV1CVTTe9czCo+NPjmpPgzh6Ui9h+FTtsLOXYpeaiFUK+Nmonsp8kxQb264OM8t4xUQHWqkfpP8j2ObC/lW4O6ZaGYz3wryYf7CygExkAC9MG8+uyxhC1kVX2yI+LKkd/aGdQYIDhP47ybsZVeYa3Au5cmwleD3tZmCYO3kiFVcXZWIjzVvoIhWb1prdvzK8M+VZ35A1T0532UObYZFP8KXEqA+C+oLmOkve34cYU/LTS6wA6erbbVMUdc971IXP1v68kEUiWSKB7E31yA/iUn9HiacEHQ4uZFsTbkvMAYd8fNhycxT6TmHGIYTSXvbMfhSLBb/koWZ7esQDUvdOPoI/munmb81YCdNghTj8B+5NXM0CWwSNqBdmyCql/hTUxqsFJVNwdK4ZmvsJLxZxmWouRzn93dNIMa4nhBrMo//gNUt3CCtV6mCz83intHELCl7KzQDwERa2HWqv4c/Dv+q4SlEfIYdUBz4Hdt1xJUdPXtDbEKwmBFh9dn7ddCmKy46tZU2Nxvp81kTVEw9BETxwFp1LxWFzZ8OtpC+mzrJvwhpPLriB7JtzGnL8Mc3b+o9yE4gohBT3Lo3tMYRD0ncRbZ+E/sW0poSgmFPcACAThNP6z+NM9wKxMG6PZor8Xtm6dwU2zkLnquJmYcVlsQ=
x-microsoft-antispam:
 BCL:0;ARA:14566002|19110799012|13091999003|8062599012|8060799015|10092599007|31061999003|12121999013|51005399006|15080799012|461199028|3412199025|440099028|40105399003|102099032|1710799026;
x-microsoft-antispam-message-info:
 =?utf-8?B?M2h3UmpsQy9ackpscDZYMXZFTTIrV0E5c3l6ZTlnZ1ZLa1F4ZEZETjM3YTRI?=
 =?utf-8?B?TG9nNXl5ZzU5N0xPcDJqcnBac1RoT21JdEdmL25hWTYva0IzSGhEcEkzNVpG?=
 =?utf-8?B?bkRMWFkvTE5YZTBrOUdnV3ljZThManZnVTMwMkV5RHlGeElLZzJ3TGs5dXRw?=
 =?utf-8?B?RFdHb1l3NHhkT2xqUjVBTUc0TnNhMjFhVzNXSFFkbldFT2VsMW9GN084eEVw?=
 =?utf-8?B?QnV1S3dEbUllRHp6QXl4SzdxWFNJYUpoWnZpU01TU0ZZK1VpZ0R4cXpyL0p1?=
 =?utf-8?B?VVhSN2NoMnF5SkswT0ptSVh1SEsxMVNiTUl5U05udWVYMkZSMERRWWU2WW5S?=
 =?utf-8?B?OWhXdEFGaHl2Y2R4Ty83T3VTdVY4azlVNlpINVR1aGl2YkRLdlpYVDVRVTl1?=
 =?utf-8?B?cit0aElKVDlBY0UremI2cnJPV0RvR2hsSGo3L3phNWVBUUMxeHVxM3pFNVpB?=
 =?utf-8?B?QzdWM3Y0VHpPSzR0bER5MnJjNnIwZTdobXVBRzJYNDJUbkFxaFV2NEExTVl2?=
 =?utf-8?B?bmMra1NXa04vVWFONUZTdUNCVGU4blJTSUY2Y3M3UVlLempOYnVJNHBvaDBu?=
 =?utf-8?B?cVg0OWdvQjFCbGZEajRiZlcwcCtRZTI3eFY1Yy8vNVFjZ0QxLzgzVWlVelNL?=
 =?utf-8?B?Rlp4d0hpZWZqR1lESnBQb1ZHellLWmpxOFNkU3RobldBWWhpSGNpeitQRGJi?=
 =?utf-8?B?Rk5vaS9ONmlEMS9FaXc1VURsVDN1SlBRYVR4aHI0V3JYK3dmWXZoWlRsV0M1?=
 =?utf-8?B?aFF6OFZWSzlqZWhUeVNlYUxicktlcGtKR0JJemcydUZVbEw2UlRSbTRaamVY?=
 =?utf-8?B?YUlOdGd1SUJvNGRXK2s3TlF0cy9wUk93N2JYcEI3STRRMmhGeFJ0QXllelVm?=
 =?utf-8?B?ekVJbWt2ZzRIZ0lJMmFweGRLcWZOVzVKQ0dKZHptN2xXMlk3eXFGWE5BUlNV?=
 =?utf-8?B?ZittSE9VbjRaYjdCNzBhY2wxeUpsRW1UellBUWtTR0FpS1V3c3lXcU9DWWdp?=
 =?utf-8?B?dElzSzVOd1IyazVmOGtuSXhQNlZNM0Z6Q0t2R0pNWGRMczdwc3piU0ZSZ2xV?=
 =?utf-8?B?dGZIcFNEMXk4VVp0eFhZaTIrMFZ5M2t5Qzl5S3BNRm1kcGEzSXdiREx0RGlK?=
 =?utf-8?B?eHJodHVYN2hsYlorK2N0ODFhYWxDcURDUllyaThLUUZGRktKS2FVaC9ZVXd0?=
 =?utf-8?B?R09WUzU2RVB1K1ZacGVUcFBEdjgrcSt1WTJrbXhUeWp0SUZDYnBFcG9nZko4?=
 =?utf-8?B?cXdvQVo1OGtjckQzMHR2RUx5YmlCaGNqOXMxTFZ4cG9nWVRpcGlNQUh5OGUy?=
 =?utf-8?B?T1lrOERUUXNMV2kvczA5c2I5MldrWkpxYy8zNS9heUFScHZtVm1UWk5DbHBt?=
 =?utf-8?B?Yk9sanlaRGd5S0hHaEdBOHV6d3FmSVcrWklZUHB5N0tFSlhpUGRHNXladE9F?=
 =?utf-8?B?QWhmQUlnS0s2UkhhOVRIcTZGZWlXZ1VwQzk5NnhUUlMyWk43dVdwRXJuaUhG?=
 =?utf-8?B?UGMyLzB0UlA2ZkNORzdvWUtSM2F0ekoyZ1RFcllaNWc1MVNDeldJWEQ5L09Z?=
 =?utf-8?B?ZzB0K3JVc0s2Qk9GMGRyOGNxSDVGVFl4U24zMWxycjRpT1RxLzN2YWZlZkNH?=
 =?utf-8?B?NDJPL3AxUjd5aWFybFVwOEhjTWNranFlcnk5VjdmZEI5VklsWUVmcXdqOXpF?=
 =?utf-8?B?SFVadTNCTTZ5L2hTTzI4UEE3NjJwK0p5VlJKbUZpRjJmdVh5QTd0dWNTY3dY?=
 =?utf-8?Q?G/EI2eFArDLdQPDlkc=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YWVoSWFQeHJKVFBRU1J0a1lic0Y4VzZ6dUdDSTN0SVNJbWJJbmlIaUFTajBh?=
 =?utf-8?B?bTFxUDNaUTNSZklOVmx2MFU0d255OFo2NFgvYUdFc1ZzTlF3QnhpRWdNbXk5?=
 =?utf-8?B?WHJ6eEZGdE84bnBPMHZKZG1lcHQ4emZxQWYvOFJpWlZCdFQ0Y2FvVW0waTd1?=
 =?utf-8?B?SGpyQWRBUWtxdVFhWHFnbC9iSnlhMVAzMitJWXFYbURNMmNXdEc2cTNlcmQy?=
 =?utf-8?B?VkZYa2ovdHlUWDNFVWFqY2xwa3dVdVRhSjNuNVpHc2hNclFnRFA1VGY4b1Jx?=
 =?utf-8?B?MHZMUXZjTElOT1Q4Szd2N1lPSWxPd24vRDRuRG1SNldLdW9Lcld5MG5SYURh?=
 =?utf-8?B?SVZvVDVJYTFvd2ltMHlSTjJZY3FIU2FFcExYYTJ2UlJkQklvb25OVk5vY2Yy?=
 =?utf-8?B?TE9RSWxxZ01tcS90Ni9MTWVYRDRRQzdZWGlkcVdicWVYc0ZzNWc4di9ISTVB?=
 =?utf-8?B?Y0lWYzkwdXRxT1ozdVFpamtJZDdBVDd5RWdKZm1PWUMrc3BUc05HbEcrYWVt?=
 =?utf-8?B?SjJubnRhSnlxU0xNeEhOSURyWlJ4aVV5VEhVMnM5dTRNYTBKWDBRMVYxbmdu?=
 =?utf-8?B?ZU5hQzlYa3BDak1zL3hQR24rajVXREI2ZkRGc0pZVlFqMGpGZElmZjlMelNV?=
 =?utf-8?B?T2RpYXBMYkhMaU5Tc3VoeHpuOWpkOTVGSGVxei9tK2tqMDFwOUN6YVUvSkFz?=
 =?utf-8?B?alVqMCtBZXRjSVF4OTBhNy92R1ZRUDVzSjdlUDcycWZlVXMwYmJENTZscW5h?=
 =?utf-8?B?MWFZcHgxV3VYNElqUysxUUZ2eXpjM05hMVN2WXIrZklYQVlZbVNRR0xHV2Fs?=
 =?utf-8?B?UlRjeEZRc3RXby9wWStYUVFPVGFFWHZIeEF1Q3dhN2VOVFQxL3U2aUtRVUlI?=
 =?utf-8?B?YXNmL3Q0LzFLN1ZWMVpoUzh3c09sUWdtRHNVQWFNa0ZUNTdNM2Naa2xMQVl1?=
 =?utf-8?B?WmhlUzI2TDY2RXJuZWw4bFVVNEtqaEVtZngxVGwzdEdMeUN4b01YYUFXUDRT?=
 =?utf-8?B?bXUwN2pFS2tyTUM5VUMrOTl3UmtvS3ZSb1Jud2oxVVVMZzBoZW13TDVXZmJo?=
 =?utf-8?B?RjMwSUpUL2Z2OE1KaGI0b0IvREFXWHg1TWJXZnRYdFRSeURicGx1dGZpV2hI?=
 =?utf-8?B?YndpQVR2K2lkUFpUbDd0YVV2SUdyUDl6ZjRXNXlVb2NmTlFLMjZCMVAzQ212?=
 =?utf-8?B?YjFPc3c5b0hHZmtLNGlDUW5rTitYUXRnMndvamw3Tk14aEE1UlZvTnRRd2hp?=
 =?utf-8?B?NmxDbGkybFgvZzJFYkcrRWkvWXE5QnRWeUtJbVBPZTByUEUrdXBYZXE0SFlk?=
 =?utf-8?B?UWs2Vk5JVUphaU9mVUFqODNPK2pxZDhLWGpiazhueFM5bm1HN3ZDNW1sNnBY?=
 =?utf-8?B?NjRDK2xkVVZ0cXNpcWpHQ2FyZHZYbVFRck1KZGtObjhuNWxQSjFhVGpGYzN1?=
 =?utf-8?B?ZTFSS2lSZXo2RFVRcnhXT0RQTGlRSUMrVVhKdUF4bm9xVDhTS0FuaUlFQWVU?=
 =?utf-8?B?K29qUHpKZWxMMU1nZW5aMS83L2NualZhMm5XdE8yR1o2UDJIZ0p5MGVVSlpZ?=
 =?utf-8?B?eE5iTEZPdm8rc2ZmeDNRWUFvZXNiQ1Q4UDhJbVByNTNWajBrNmpvU0xOSXZP?=
 =?utf-8?Q?jwPv98dsZPvavf5O77N/V2mKWXcCIpxBulvBMQKJXOJE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR02MB4157.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7f6b6b-4572-4390-6225-08de2192dc99
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 02:26:18.3095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9102

RnJvbTogTWljaGFlbCBLZWxsZXkgPG1oa2xpbnV4QG91dGxvb2suY29tPiBTZW50OiBUdWVzZGF5
LCBOb3ZlbWJlciAxMSwgMjAyNSA1OjM5IFBNDQo+IA0KPiBGcm9tOiBKb3NoIFBvaW1ib2V1ZiA8
anBvaW1ib2VAa2VybmVsLm9yZz4gU2VudDogVHVlc2RheSwgTm92ZW1iZXIgMTEsIDIwMjUgMTI6
MDkgUE0NCj4gPg0KPiA+IE9uIFdlZCwgTm92IDA1LCAyMDI1IGF0IDAzOjIyOjU4UE0gKzAwMDAs
IE1pY2hhZWwgS2VsbGV5IHdyb3RlOg0KPiA+ID4gPiBUaGFua3MgZm9yIHJlcG9ydGluZyB0aGF0
LiAgSSBzdXBwb3NlIHNvbWV0aGluZyBsaWtlIHRoZSBiZWxvdyB3b3VsZCB3b3JrPw0KPiA+ID4g
Pg0KPiA+ID4gPiBUaG91Z2gsIG1heWJlIHRoZSBtaXNzaW5nIHh4aGFzaCBzaG91bGRuJ3QgZmFp
bCB0aGUgYnVpbGQgYXQgYWxsLiAgSXQncw0KPiA+ID4gPiByZWFsbHkgb25seSBuZWVkZWQgZm9y
IHBlb3BsZSB3aG8gYXJlIGFjdHVhbGx5IHRyeWluZyB0byBydW4ga2xwLWJ1aWxkLg0KPiA+ID4g
PiBJIG1heSBsb29rIGF0IGltcHJvdmluZyB0aGF0Lg0KPiA+ID4NCj4gPiA+IFllcywgdGhhdCB3
b3VsZCBwcm9iYWJseSBiZSBiZXR0ZXIuDQo+ID4gPg0KPiA+ID4gPg0KPiA+ID4gPiBkaWZmIC0t
Z2l0IGEvdG9vbHMvb2JqdG9vbC9NYWtlZmlsZSBiL3Rvb2xzL29ianRvb2wvTWFrZWZpbGUNCj4g
PiA+ID4gaW5kZXggNDg5MjhjOWJlYmVmMS4uOGI5NTE2NmIzMTYwMiAxMDA2NDQNCj4gPiA+ID4g
LS0tIGEvdG9vbHMvb2JqdG9vbC9NYWtlZmlsZQ0KPiA+ID4gPiArKysgYi90b29scy9vYmp0b29s
L01ha2VmaWxlDQo+ID4gPiA+IEBAIC0xMiw3ICsxMiw3IEBAIGlmZXEgKCQoU1JDQVJDSCksbG9v
bmdhcmNoKQ0KPiA+ID4gPiAgZW5kaWYNCj4gPiA+ID4NCj4gPiA+ID4gIGlmZXEgKCQoQVJDSF9I
QVNfS0xQKSx5KQ0KPiA+ID4gPiAtCUhBVkVfWFhIQVNIID0gJChzaGVsbCBlY2hvICJpbnQgbWFp
bigpIHt9IiB8IFwNCj4gPiA+ID4gKwlIQVZFX1hYSEFTSCA9ICQoc2hlbGwgZWNobyAtZSAiI2lu
Y2x1ZGUgPHh4aGFzaC5oPlxuWFhIM19zdGF0ZV90ICpzdGF0ZTtpbnQgbWFpbigpIHt9IiB8IFwN
Cj4gPiA+ID4gIAkJICAgICAgJChIT1NUQ0MpIC14YyAtIC1vIC9kZXYvbnVsbCAtbHh4aGFzaCAy
PiAvZGV2L251bGwgJiYgZWNobyB5IHx8IGVjaG8gPiBuKQ0KPiA+ID4gPiAgCWlmZXEgKCQoSEFW
RV9YWEhBU0gpLHkpDQo+ID4gPiA+ICAJCUJVSUxEX0tMUAkgOj0geQ0KPiA+ID4NCj4gPiA+IElu
ZGVlZCB0aGlzIGlzIHdoYXQgSSBoYWQgaW4gbWluZCBmb3IgdGhlIGVuaGFuY2VkIGNoZWNrLiBC
dXQgdGhlIGFib3ZlDQo+ID4gPiBnZXRzIGEgc3ludGF4IGVycm9yOg0KPiA+ID4NCj4gPiA+IE1h
a2VmaWxlOjE1OiAqKiogdW50ZXJtaW5hdGVkIGNhbGwgdG8gZnVuY3Rpb24gJ3NoZWxsJzogbWlz
c2luZyAnKScuICBTdG9wLg0KPiA+ID4gbWFrZVs0XTogKioqIFtNYWtlZmlsZTo3Mzogb2JqdG9v
bF0gRXJyb3IgMg0KPiA+ID4NCj4gPiA+IEFzIGEgZGVidWdnaW5nIGV4cGVyaW1lbnQsIGFkZGlu
ZyBvbmx5IHRoZSAtZSBvcHRpb24gdG8gdGhlIGV4aXN0aW5nIGNvZGUNCj4gPiA+IGxpa2UgdGhp
cyBzaG91bGRuJ3QgYWZmZWN0IGFueXRoaW5nLA0KPiA+ID4NCj4gPiA+IAlIQVZFX1hYSEFTSCA9
ICQoc2hlbGwgZWNobyAtZSAiaW50IG1haW4oKSB7fSIgfCBcDQo+ID4gPg0KPiA+ID4gYnV0IGl0
IGNhdXNlcyBIQVZFX1hYSEFTSCB0byBhbHdheXMgYmUgJ24nIGV2ZW4gaWYgdGhlIHh4aGFzaCBs
aWJyYXJ5DQo+ID4gPiBpcyBwcmVzZW50LiBTbyB0aGUgLWUgb3B0aW9uIGlzIHNvbWVob3cgZm91
bGluZyB0aGluZ3MgdXAuDQo+ID4gPg0KPiA+ID4gUnVubmluZyB0aGUgZXF1aXZhbGVudCBpbnRl
cmFjdGl2ZWx5IGF0IGEgJ2Jhc2gnIHByb21wdCB3b3JrcyBhcyBleHBlY3RlZC4NCj4gPiA+IEFu
ZCB5b3VyIHByb3Bvc2VkIHBhdGNoIHdvcmtzIGNvcnJlY3RseSBpbiBhbiBpbnRlcmFjdGl2ZSBi
YXNoLiBTbw0KPiA+ID4gc29tZXRoaW5nIHdlaXJkIGlzIGhhcHBlbmluZyBpbiB0aGUgY29udGV4
dCBvZiBtYWtlJ3Mgc2hlbGwgZnVuY3Rpb24sDQo+ID4gPiBhbmQgSSBoYXZlbid0IGJlZW4gYWJs
ZSB0byBmaWd1cmUgb3V0IHdoYXQgaXQgaXMuDQo+ID4gPg0KPiA+ID4gRG8geW91IGdldCB0aGUg
c2FtZSBmYWlsdXJlcz8gT3IgaXMgdGhpcyBzb21lIGtpbmQgb2YgcHJvYmxlbSB3aXRoDQo+ID4g
PiBteSBlbnZpcm9ubWVudD8gIEkndmUgZ290IEdOVSBtYWtlIHZlcnNpb24gNC4yLjEuDQo+ID4N
Cj4gPiBUaGF0J3Mgd2VpcmQsIGl0IGJ1aWxkcyBmaW5lIGZvciBtZS4gIEkgaGF2ZSBHTlUgbWFr
ZSA0LjQuMS4NCj4gDQo+IEkndmUgYmVlbiBhYmxlIHRvIGRlYnVnIHRoaXMuICBUd28gcHJvYmxl
bXM6DQo+IA0KPiAxKSBPbiBVYnVudHUgKGJvdGggMjAuMDQgYW5kIDI0LjA0KSwgL2Jpbi9zaCBh
bmQgL3Vzci9iaW4vc2ggYXJlIHN5bWxpbmtzDQo+IHRvICJkYXNoIiAobm90ICJiYXNoIikuIFNv
IHRoZSAic2hlbGwiIGNvbW1hbmQgaW4gIm1ha2UiIGludm9rZXMgZGFzaC4gVGhlDQo+IG1hbiBw
YWdlIGZvciBkYXNoIHNob3dzIHRoYXQgdGhlIGJ1aWx0LWluIGVjaG8gY29tbWFuZCBhY2NlcHRz
IG9ubHkgLW4gYXMNCj4gYW4gb3B0aW9uLiBUaGUgLWUgYmVoYXZpb3Igb2YgcHJvY2Vzc2luZyAi
XG4iIGFuZCBzaW1pbGFyIHNlcXVlbmNlcyBpcyBhbHdheXMNCj4gZW5hYmxlZC4gU28gb24gbXkg
VWJ1bnR1IHN5c3RlbXMsIHRoZSAiLWUiIGlzIGlnbm9yZWQgYnkgZWNobyBhbmQgYmVjb21lcw0K
PiBwYXJ0IG9mIHRoZSBDIHNvdXJjZSBjb2RlIHNlbnQgdG8gZ2NjLCBhbmQgb2YgY291cnNlIGl0
IGJhcmZzLiBEcm9wcGluZyB0aGUgLWUNCj4gbWFrZXMgaXQgd29yayBmb3IgbWUgKGFuZCB0aGUg
XG4gaXMgaGFuZGxlZCBjb3JyZWN0bHkpLCBidXQgdGhhdCBtaWdodCBub3Qgd29yaw0KPiB3aXRo
IG90aGVyIHNoZWxscy4gVXNpbmcgIi9iaW4vZWNobyIgd2l0aCB0aGUgLWUgc29sdmVzIHRoZSBw
cm9ibGVtIGluIGEgbW9yZQ0KPiBjb21wYXRpYmxlIHdheSBhY3Jvc3MgZGlmZmVyZW50IHNoZWxs
cy4NCj4gDQo+IDIpIFdpdGggbWFrZSB2NC4yLjEgb24gbXkgVWJ1bnR1IDIwLjA0IHN5c3RlbSwg
dGhlICIjIiBjaGFyYWN0ZXIgaW4gdGhlDQo+ICIjaW5jbHVkZSIgYWRkZWQgdG8gdGhlIGVjaG8g
Y29tbWFuZCBpcyBwcm9ibGVtYXRpYy4gIm1ha2UiIHNlZW1zIHRvIGJlDQo+IHRyZWF0aW5nIGl0
IGFzIGEgY29tbWVudCBjaGFyYWN0ZXIsIHRob3VnaCBJJ20gbm90IDEwMCUgc3VyZSBvZiB0aGF0
DQo+IGludGVycHJldGF0aW9uLiBSZWdhcmRsZXNzLCB0aGUgIiMiIGNhdXNlcyBhIHN5bnRheCBl
cnJvciBpbiB0aGUgIm1ha2UiIHNoZWxsDQo+IGNvbW1hbmQuIEFkZGluZyBhIGJhY2tzbGFzaCBi
ZWZvcmUgdGhlICIjIiBzb2x2ZXMgdGhhdCBwcm9ibGVtLiBPbiBhbiBVYnVudHUNCj4gMjQuMDQg
c3lzdGVtIHdpdGggbWFrZSB2NC4zLCB0aGUgIiMiIGRvZXMgbm90IGNhdXNlIGFueSBwcm9ibGVt
cy4gKEkgdHJpZWQgdG8gcHV0DQo+IG1ha2UgNC4zIG9uIG15IFVidW50dSAyMC4wNCBzeXN0ZW0s
IGJ1dCByYW4gaW50byBsaWJyYXJ5IGNvbXBhdGliaWxpdHkgcHJvYmxlbXMNCj4gc28gSSB3YXNu
4oCZdCBhYmxlIHRvIGRlZmluaXRpdmVseSBjb25maXJtIHRoYXQgaXQgaXMgdGhlIG1ha2UgdmVy
c2lvbiB0aGF0IGNoYW5nZXMgdGhlDQo+IGhhbmRsaW5nIG9mIHRoZSAiIyIpLiBVbmZvcnR1bmF0
ZWx5LCBhZGRpbmcgdGhlIGJhY2tzbGFzaCBiZWZvcmUgdGhlICMgZG9lcyAqbm90Kg0KPiB3b3Jr
IHdpdGggbWFrZSB2NC4zLiBUaGUgYmFja3NsYXNoIGJlY29tZXMgcGFydCBvZiB0aGUgQyBzb3Vy
Y2UgY29kZSBzZW50IHRvDQo+IGdjYywgd2hpY2ggYmFyZnMuIEkgZG9uJ3QgaW1tZWRpYXRlbHkg
aGF2ZSBhIHN1Z2dlc3Rpb24gb24gaG93IHRvIHJlc29sdmUgdGhpcw0KPiBpbiBhIHdheSB0aGF0
IGlzIGNvbXBhdGlibGUgYWNyb3NzIG1ha2UgdmVyc2lvbnMuDQoNClVzaW5nICJcMDQzIiBpbnN0
ZWFkIG9mIHRoZSAiIyIgaXMgYSBjb21wYXRpYmxlIHNvbHV0aW9uIHRoYXQgd29ya3MgaW4gbWFr
ZQ0KdjQuMi4xIGFuZCB2NC4zIGFuZCBwcmVzdW1hYmx5IGFsbCBvdGhlciB2ZXJzaW9ucyBhcyB3
ZWxsLg0KDQpNaWNoYWVsDQo=

