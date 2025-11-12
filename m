Return-Path: <live-patching+bounces-1837-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44ED2C50899
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 05:34:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A95D03A4329
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 04:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43BCF2D0C7E;
	Wed, 12 Nov 2025 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="qOwsbvKc"
X-Original-To: live-patching@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazolkn19012068.outbound.protection.outlook.com [52.103.14.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B3B78F5D;
	Wed, 12 Nov 2025 04:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.14.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762921927; cv=fail; b=l6COwnO2wedh+ru85KMcnvGvpb2uHGrEeO37oECb2Xt0Oj1W3L62s9NIFkI17xIWmAjQ/EEIvx/vS/Q+WKmPJebV+gVFGJB17hANtofOKQaBniYNLQzxN/Ys1gemnh83DItoM+Twvzh++qkXRcHezqzktXYneL7mKAe+YxwMcz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762921927; c=relaxed/simple;
	bh=/7tbcPz0FJYGYKlntXL6ePwG4WK2ux6cCcWfFnmjz1k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IkpOBkadX8cJAUg9Lv/HuVei8hQVWng8yieHSUrd1S/FL8Y8c5zmE8w0XV/rTQ8nCBnk5QqfdlZZWHVz7jiammxu6Ek6oSNXqcMlWcJGhV4VXYL/wDPbw0wFSnPmGYEpF0031DgzGwORkOk6dbosEz57AI1RDDwjechp6v5Xji8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=qOwsbvKc; arc=fail smtp.client-ip=52.103.14.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ChxaUUzfQMon4eDL69BxWQAs5nDmE/BjIETcNYIl5drM3OYLK3HZFuBEjlnhJgF8BTygRwDuBdk5wkKZJSKuwqxirFGCG/hK6zgHXSYU9H+IBcesCDQ1RLac9BMrXsOZekzn1zm+JXOWgSuoaeSRwDvpB1imF/IPlTCJmsW1ozDf8KVWGXcOTJz6ZHic3UlxBphoUW3Tqs2PLKJXNpBO81AoRkJiiI5wXz8mKFyXh8Ez7PjjO0Ii4KJovKk5doHFNtdSlGdejsyVYzC4nLpk5KZxEPoZGdX+0EzON0+NyCwe40/Z0zcxxy/nnr7pVAiEYvYFdQe1WDZnQ6wKCv4GRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/7tbcPz0FJYGYKlntXL6ePwG4WK2ux6cCcWfFnmjz1k=;
 b=XkCHXCvuVVphgY3d1JUjPP1qNytg32NWoF5WfBwH8i9vfrzHv5bX7e7ukpjYqQmZ++kPFUE7eUcz+BmUI8lzEI9Ej32UTGm12htheY7tNTwbFuvWgh/ARdRxvmpzPWIKaN9rypUc+gPCi9zaG2s7eLFZL4xVj6frFWxxci5B1FaRVZXUcdDKA61ZhkGrPGrzqZyRMyh4JS4HIJK8/5EQVkccQ+dfPFaIrdiav5utf5XVHfTraQ3ytB2qKHQyrebsySflrL8ir1HKqCq0IO6OzZZPpbRoYXSt0rd6Fnzxp2201426Y0KM8aImnsdOGwaXHMQnomXnxPhjytVHAiqgLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/7tbcPz0FJYGYKlntXL6ePwG4WK2ux6cCcWfFnmjz1k=;
 b=qOwsbvKczOb5KGyq3vzX4bFJG3z4Qw4mo8aYwP2wn0ndrDdUcIDyo57HP3C5B9SWUAbIEVKaKzU9l17QbF+BuhWezjCSCzrnA4x6LKH09wL7u1nMRsOP1Y4NYPM2qOfpEvi9WEmeA+HJCx3MSA/9ylqXfuo3cCxuRdeuT89PBu8icUgS+0tIT40Andtdj+e6Mekd4iT/s0R46UKuLj1AOLSAEob28bpCqHB7ZSEtfnxwuIvccgZgkp9KAHpvqyyXT9k6zexKoZfEPnIb6YMnbSRVv59fLW6OtDSK+3NGjO6QURnMqGhYIlZl7CuEV4el3E5ixa2ZglYqOm8lV2IzpA==
Received: from BN7PR02MB4148.namprd02.prod.outlook.com (2603:10b6:406:f6::17)
 by IA0PR02MB9631.namprd02.prod.outlook.com (2603:10b6:208:40f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 04:32:02 +0000
Received: from BN7PR02MB4148.namprd02.prod.outlook.com
 ([fe80::6007:d1a1:bcf9:58ef]) by BN7PR02MB4148.namprd02.prod.outlook.com
 ([fe80::6007:d1a1:bcf9:58ef%4]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 04:32:02 +0000
From: Michael Kelley <mhklinux@outlook.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
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
 AQHcJ+6qpEmfJskj+02bf6oIo51EqLTUFK6ggAK7zwCAAjZrQIAVN1sAgABS88CAABWQMIAAHDOAgAAHCFA=
Date: Wed, 12 Nov 2025 04:32:02 +0000
Message-ID:
 <BN7PR02MB414887B3CA73281177406A5BD4CCA@BN7PR02MB4148.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
 <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <SN6PR02MB4157F236604B6780327E6B43D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
In-Reply-To: <yk3ku4ud35rsrfwzvuqnrcnwogwngqlmc3otxrnoqefb47ajm7@orl5gcxuwrme>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR02MB4148:EE_|IA0PR02MB9631:EE_
x-ms-office365-filtering-correlation-id: cb6ef2fd-c7f4-4921-47b0-08de21a46d48
x-ms-exchange-slblob-mailprops:
 WaIXnCbdHrNsJbj7NxvUrpSYkT7K1zyUu3suhFt4KDuLoWe4rim38BVHDT5ZpSvwby2Jz3AOKM4dbJAJlUadM/6Hxyip2B/qg8Xwd7aAsl6A8cJr60FYnpGG2PMw8hnjp6RkPpJw+lqHvvCRELkHB4SfqGnEWeITnaGpElTH8H0tXZA8Tf5+JOkYmWTakIimYttRlgNb7dUiueaCmQV5eIQ6jSMaf6tDTB42dzdMQB87Z954Y+OOXQGsDOAP5UDnOfN1F+3jJOU6u0gHqtkiiytnzx+VKu2Z6/p2LI6HS9hryWHZQKRPW5AKR3Hx/XLzYwOgE5B1A4Znxui+/UfQsc8XHBaQDp7BBVrc43c5Ty6nsjVOFv6iOQn0iUp7k2Qii6sInwTYatqcW5dR+P/CyO/ny1Rf0mU7uCs2t/zmNgp4pyHzcuKSOOcyTzUD0UVaRYDaTgPUYFmzZK8JtC1pD9UiECPC/EdGuWWJE6dJlIXhQLenKarjWmU3hwidneFibSMftbsut5PduLIv0o356LW0TwJLn2ILLF7jPdgVEy1SKGtwrJuncumoW24nJ1ao0Sw/6472EZfPJDp4zRUwnuABFq9NPeHfVKSNqT81zM64rwBd27dzzH8M+wkfPdsSOSbiwyEBNvKmEm0bXmz3WCnLB8uk1XlSjyWCvmGt902S325DKULc/YhGG9EGUzDLZjHObMay2fDQoFgDH0mgjV4mSOkNbMgnA4Qasgd069dkqaGW8lsFyzT0hEnXGK+vphp2iEEGKBQ=
x-microsoft-antispam:
 BCL:0;ARA:14566002|13091999003|461199028|8062599012|8060799015|10092599007|15080799012|51005399006|19110799012|31061999003|3412199025|440099028|40105399003|102099032;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZFF5NEtwZCtON2xVUktVbldkRnpYZWVPRmw1cDdUN0M3aTU2bllEbFFtMHdD?=
 =?utf-8?B?SDltRFFZdTNCRVFTdXNrL0l4K1A0QVQrZmJmeGg0RU5DYU9idmRzZ0p6K3ZT?=
 =?utf-8?B?QmZVTjNBaXg2RllmWDVHS0NKbWR3N2VKMXBJK3dIVU5ZY2Q3NGNCVVdLQW5k?=
 =?utf-8?B?RW1aWUt0N1RsV2E2NjVPbVgvT3BkVnJJdC9kMTYxS2NRUFVEbjhtS0xKYXpQ?=
 =?utf-8?B?ZzV4b2VwQ0FoZTQ0SDVjTUxOOHVYUm1LUzFUWWx2UU5YYTBBaGVENW5UaVpt?=
 =?utf-8?B?Z1ByOG90VmpvM3JPdzRraWpLTDB0TnlPeHNOdll1RjdXN0JicHdleVNPVmNX?=
 =?utf-8?B?aHpBWWptaTN1WS9xQkpwZ0MzK0pzWWRsb1RGd1FrWkxxc0lIN0dIcDVRMHJI?=
 =?utf-8?B?d0tVS2xTUFJJcnpWclpoVUprV1RmU0NuR05NbG9pQkZrem1wRlBTeS83WUZp?=
 =?utf-8?B?VHNyTjl6WkpOKzlyd0tpdkVHVTYwSnNJVHB3cEFKV1c4Z1pjNURwUW56eG5q?=
 =?utf-8?B?Z0tHVXI2dmdhSWdQa1pyWWJzYWlPQjlUcXg3TGllS0pHaE5LSHlkYlVXdnQ5?=
 =?utf-8?B?ZGdwV1gzZndCd1VsRDRMc29yQ0xoaEI3T2ZTWHBVNm9EMjN4RmhpUU5lU2pD?=
 =?utf-8?B?SlhNQXZTNERvaFF2eXkxem9OOHF5bGpvdURpeFBDaUZscEM4VW56M1F5aXN3?=
 =?utf-8?B?Z04zRlJUa3VINmhvM0I2VEJVSVpTNG1VeG8rOVd5eUwwaS91UG91cmdvTzF0?=
 =?utf-8?B?bTNscWFINHZkSkpudkoyVmcxSnlrTzMzYmdBUU9CQ3dZV1ZqcHozZmhlcW9R?=
 =?utf-8?B?UTdnaXBZaTlYaUE5Z0ZaQThiOEVOM2hTMzQ3YVB1WmNpNGJUWXU3MDVQYzhS?=
 =?utf-8?B?bUNxZmo4Qm5pQTFLTmRwa0dBZDQxekJXN1RLWlpsMkMyK0tDWXIxOU1CRmlS?=
 =?utf-8?B?TlE5ZWoySXFFMkt2T0g4RGZmdlBrU2lWZFdreDZLOVNxb2VFQVh0cFJkTW1r?=
 =?utf-8?B?aXQyZGdteHFhNWpUTDJQZ1VjeFFuaThRNTVLY3NXb3JXZXJITnFEcVEyU3Ji?=
 =?utf-8?B?UExyR3J1Tm16VnhNY29qazBQVjRKT2Jpd2tuQ21VTkFYUXdzOUNocTVxbFJz?=
 =?utf-8?B?QWNSWjc0Q1d6Q3U5SHNxSjMzNmlZUlRGZzl1Yy83VTZUODdDMEIrd2JSdERl?=
 =?utf-8?B?S3FKTEVKdFBmdFo4RXFwMHFvV2liN1B3U2RTZWRTOFVEZjFnOEVPWUY0ZVht?=
 =?utf-8?B?dTRZM0tKYkJrbmdseTA5bGZrWG9KYjIzMFlMNlFnZkdiM0t1Ti8xMEFBUUlJ?=
 =?utf-8?B?R3hvYzZyVFJMc0tIQ092SkpDSFlnNEpaOURWNTNtWTREcXVoQU1MUFNlVnZm?=
 =?utf-8?B?QUZndGwrcmVuOUNiMmRMRWhIVEJWb2RxNENOQ2wzN2lYak9KU2p6emRqa0Iw?=
 =?utf-8?B?Um8xbFVieUxwM1h2dmRxYjZUVzZiLzlwRUtVUkh0RjkrVS9PNHRTSDk5VWtP?=
 =?utf-8?B?L0xzVlpBaEd4d3VGUDVhbzBWMEtuRE1JSExMa3FJc0gxYVVFek5Pd2x0Skty?=
 =?utf-8?B?ZkFvdjllSlpXWG4xOXZEVFVyMExNV3MvcFlOemtCUU9qMzNJcTBHdURJVDA0?=
 =?utf-8?Q?7+kaJ2/ZzAp98FFwW+o9qq721PwAHUA7J7+bd0S4Lw3I=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QTJZUGtyd3NyZHc1WjM5WDZmNDFtWC8ya3o0Z2tXanFYMnMveHZoNUF3VWJh?=
 =?utf-8?B?eVFFSm9RMHV4UjhJYnJhdEo2SlJPRTVGMGl5dU1OSytyTHpZNTY0NndDVzJr?=
 =?utf-8?B?d1NxZmo3aFdSNFNUVlFFRS90Yk1lME03UWY5alF0bFc3ZzJHbVJGaTJzcGRI?=
 =?utf-8?B?T2NsSW9kcFhUZFlKZmpKamdsVnNkekNwSGV5MWFzV1VMWDlYMkg5N3lRQWow?=
 =?utf-8?B?L1FXbVVNRXgxYXlvK0EwdXVISzM2VWsra1NpTXpLRkxHbFdUQ3ZxcEtTMVEr?=
 =?utf-8?B?SVpDYkhWWittN0dUWHJSMGFORnYwcjBMclZNNkFKcnk1MFozNTFwbmk3cTNI?=
 =?utf-8?B?aHdJRlpBR0hBNGhma3NKOW4xSWx3S3E2Z1luYVZjaVdkT01XV3NnTHY3VVMz?=
 =?utf-8?B?Q2xjVnYzQmdwb2ZGNW0raFJVZm1HUDk5MGl5Zk1Tby9sR05lWUIvbEZ1b0RR?=
 =?utf-8?B?b2FvY0VxKzdjUzdzZXdHbWF1ZEE2WU10YkIxWlhHK0JqaWFYelEyMnAxMDhV?=
 =?utf-8?B?aWJjaFlLeTdmMTd4cHNJOGhaOWx1eCsrR3B3ZVNpOWdwNUhMTTJYQXFtWnh3?=
 =?utf-8?B?Y0dySWlzK2RqZ3JXQmJPOTZhRjV6NkQ0NXBJazlxalpHa2FPZksyWU1iM05u?=
 =?utf-8?B?ZnpSUGJXM2ZvbXRRTHhyTDZPMVJoazhLVTF1VWRLaUZBa09GaEpoT05FUm5J?=
 =?utf-8?B?OURrVkorUHFnbmdiNzlteXRaS2lHbjUveTV1TU1jN044aFdWYWxyelZ6S0Jw?=
 =?utf-8?B?ZEtBcUhSZHd1ZXUzNlRPZnA5RUlCZzlqbDZDT1ZBeFFmZUcrWGhqK3p4eU5O?=
 =?utf-8?B?dHVGNUZVYXY1UFdFcXNobUN3V0NJaFZOQ1dhRTdNZ0tjTFIrcmNiY240Rytv?=
 =?utf-8?B?OHU1WC95QWxDRlhYU01zZ05sME1tWTRMcTU3d0s5RXpDVXhlV1NHTVZkd25v?=
 =?utf-8?B?WE0zSVAxRDN3WlFHdmNYd2NZbXgvUGJsaWxBVEd6TUhpVzVXYXg1VHVLdUZL?=
 =?utf-8?B?NTdkSGZzVFpaZ09ZcnVHSlhMc09QQ0EydlpreWlnK00zazVuK2ZWTTZhbnEz?=
 =?utf-8?B?N3RHT081TFAwNEQ1Q283cnIzUUVSTkZ3ajh4VnF0aW4xM0xDSUdtMkd3dEdj?=
 =?utf-8?B?Q2V3VS9EMm5QcE9pV3RVUWRrdS8wRzBKSFhFUDZ5RE9Pci9KY0E5bnRiRXg2?=
 =?utf-8?B?U0s4aFZOMnpSTG93NXFOaExkY1pzaTJva0ZYd05pcU1HR1pkVkMyOTVTTDJt?=
 =?utf-8?B?Mkw4cnJHd21vMVpKZWFmQkg3cG5CWVk5MTRjZXlUbnlTeTl4Uk5SaXlOTFpZ?=
 =?utf-8?B?QzNXYXRDY3g4a3NSbmV2ZC9LK2RvenBnR1F4c01jempWTVg1ajNDbmNKVmh1?=
 =?utf-8?B?NUpidTgxc3BkN0dTbHZwUGVvTmdGd0JWYXhLQTdsT3dndEZMeDNjVE1aWGpw?=
 =?utf-8?B?T2E1SlNVREZOcllNRC9LNm1nQ0NKZThlUS9nTENWd0NjYmRXVTRWckpPMFJK?=
 =?utf-8?B?bXB5US8wNXZwcUdMWDV2R2dFZGVodnJ4YXFrMXZpaExCejdIWFRNdGFjWHZP?=
 =?utf-8?B?ckRkMDNnanp2Zm1ja0JDNCszRER5ZEdrR1NlVmRNekFpQklhSEEwTGhJOUt0?=
 =?utf-8?Q?Pl4m8z3mLzBkSamWUqEn3vs3GSRzzkpC06KjJAt/b49M=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: BN7PR02MB4148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6ef2fd-c7f4-4921-47b0-08de21a46d48
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 04:32:02.4469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9631

RnJvbTogSm9zaCBQb2ltYm9ldWYgPGpwb2ltYm9lQGtlcm5lbC5vcmc+IFNlbnQ6IFR1ZXNkYXks
IE5vdmVtYmVyIDExLCAyMDI1IDg6MDQgUE0NCj4gDQo+IE9uIFdlZCwgTm92IDEyLCAyMDI1IGF0
IDAyOjI2OjE4QU0gKzAwMDAsIE1pY2hhZWwgS2VsbGV5IHdyb3RlOg0KPiA+ID4gSSd2ZSBiZWVu
IGFibGUgdG8gZGVidWcgdGhpcy4gIFR3byBwcm9ibGVtczoNCj4gPiA+DQo+ID4gPiAxKSBPbiBV
YnVudHUgKGJvdGggMjAuMDQgYW5kIDI0LjA0KSwgL2Jpbi9zaCBhbmQgL3Vzci9iaW4vc2ggYXJl
IHN5bWxpbmtzDQo+ID4gPiB0byAiZGFzaCIgKG5vdCAiYmFzaCIpLiBTbyB0aGUgInNoZWxsIiBj
b21tYW5kIGluICJtYWtlIiBpbnZva2VzIGRhc2guIFRoZQ0KPiA+ID4gbWFuIHBhZ2UgZm9yIGRh
c2ggc2hvd3MgdGhhdCB0aGUgYnVpbHQtaW4gZWNobyBjb21tYW5kIGFjY2VwdHMgb25seSAtbiBh
cw0KPiA+ID4gYW4gb3B0aW9uLiBUaGUgLWUgYmVoYXZpb3Igb2YgcHJvY2Vzc2luZyAiXG4iIGFu
ZCBzaW1pbGFyIHNlcXVlbmNlcyBpcyBhbHdheXMNCj4gPiA+IGVuYWJsZWQuIFNvIG9uIG15IFVi
dW50dSBzeXN0ZW1zLCB0aGUgIi1lIiBpcyBpZ25vcmVkIGJ5IGVjaG8gYW5kIGJlY29tZXMNCj4g
PiA+IHBhcnQgb2YgdGhlIEMgc291cmNlIGNvZGUgc2VudCB0byBnY2MsIGFuZCBvZiBjb3Vyc2Ug
aXQgYmFyZnMuIERyb3BwaW5nIHRoZSAtZQ0KPiA+ID4gbWFrZXMgaXQgd29yayBmb3IgbWUgKGFu
ZCB0aGUgXG4gaXMgaGFuZGxlZCBjb3JyZWN0bHkpLCBidXQgdGhhdCBtaWdodCBub3Qgd29yaw0K
PiA+ID4gd2l0aCBvdGhlciBzaGVsbHMuIFVzaW5nICIvYmluL2VjaG8iIHdpdGggdGhlIC1lIHNv
bHZlcyB0aGUgcHJvYmxlbSBpbiBhIG1vcmUNCj4gPiA+IGNvbXBhdGlibGUgd2F5IGFjcm9zcyBk
aWZmZXJlbnQgc2hlbGxzLg0KPiANCj4gQWguICBJIHRoaW5rIHdlIGNhbiB1c2UgInByaW50ZiIg
aGVyZS4NCj4gDQo+ID4gPiAyKSBXaXRoIG1ha2UgdjQuMi4xIG9uIG15IFVidW50dSAyMC4wNCBz
eXN0ZW0sIHRoZSAiIyIgY2hhcmFjdGVyIGluIHRoZQ0KPiA+ID4gIiNpbmNsdWRlIiBhZGRlZCB0
byB0aGUgZWNobyBjb21tYW5kIGlzIHByb2JsZW1hdGljLiAibWFrZSIgc2VlbXMgdG8gYmUNCj4g
PiA+IHRyZWF0aW5nIGl0IGFzIGEgY29tbWVudCBjaGFyYWN0ZXIsIHRob3VnaCBJJ20gbm90IDEw
MCUgc3VyZSBvZiB0aGF0DQo+ID4gPiBpbnRlcnByZXRhdGlvbi4gUmVnYXJkbGVzcywgdGhlICIj
IiBjYXVzZXMgYSBzeW50YXggZXJyb3IgaW4gdGhlICJtYWtlIiBzaGVsbA0KPiA+ID4gY29tbWFu
ZC4gQWRkaW5nIGEgYmFja3NsYXNoIGJlZm9yZSB0aGUgIiMiIHNvbHZlcyB0aGF0IHByb2JsZW0u
IE9uIGFuIFVidW50dQ0KPiA+ID4gMjQuMDQgc3lzdGVtIHdpdGggbWFrZSB2NC4zLCB0aGUgIiMi
IGRvZXMgbm90IGNhdXNlIGFueSBwcm9ibGVtcy4gKEkgdHJpZWQgdG8gcHV0DQo+ID4gPiBtYWtl
IDQuMyBvbiBteSBVYnVudHUgMjAuMDQgc3lzdGVtLCBidXQgcmFuIGludG8gbGlicmFyeSBjb21w
YXRpYmlsaXR5IHByb2JsZW1zDQo+ID4gPiBzbyBJIHdhc27igJl0IGFibGUgdG8gZGVmaW5pdGl2
ZWx5IGNvbmZpcm0gdGhhdCBpdCBpcyB0aGUgbWFrZSB2ZXJzaW9uIHRoYXQgY2hhbmdlcyB0aGUN
Cj4gPiA+IGhhbmRsaW5nIG9mIHRoZSAiIyIpLiBVbmZvcnR1bmF0ZWx5LCBhZGRpbmcgdGhlIGJh
Y2tzbGFzaCBiZWZvcmUgdGhlICMgZG9lcyAqbm90Kg0KPiA+ID4gd29yayB3aXRoIG1ha2UgdjQu
My4gVGhlIGJhY2tzbGFzaCBiZWNvbWVzIHBhcnQgb2YgdGhlIEMgc291cmNlIGNvZGUgc2VudCB0
bw0KPiA+ID4gZ2NjLCB3aGljaCBiYXJmcy4gSSBkb24ndCBpbW1lZGlhdGVseSBoYXZlIGEgc3Vn
Z2VzdGlvbiBvbiBob3cgdG8gcmVzb2x2ZSB0aGlzDQo+ID4gPiBpbiBhIHdheSB0aGF0IGlzIGNv
bXBhdGlibGUgYWNyb3NzIG1ha2UgdmVyc2lvbnMuDQo+ID4NCj4gPiBVc2luZyAiXDA0MyIgaW5z
dGVhZCBvZiB0aGUgIiMiIGlzIGEgY29tcGF0aWJsZSBzb2x1dGlvbiB0aGF0IHdvcmtzIGluIG1h
a2UNCj4gPiB2NC4yLjEgYW5kIHY0LjMgYW5kIHByZXN1bWFibHkgYWxsIG90aGVyIHZlcnNpb25z
IGFzIHdlbGwuDQo+IA0KPiBIbS4uLiBJJ3ZlIHNlZW4gc2ltaWxhciBwb3J0YWJpbGl0eSBpc3N1
ZXMgd2l0aCAiLCIgZm9yIHdoaWNoIHdlIGhhZCB0bw0KPiBjaGFuZ2UgaXQgdG8gIiQoY29tbWEp
IiB3aGljaCBtYWdpY2FsbHkgd29ya2VkIGZvciBzb21lIHJlYXNvbiB0aGF0IEkgYW0NCj4gZm9y
Z2V0dGluZy4NCj4gDQo+IERvZXMgIiQocG91bmQpIiB3b3JrPyAgVGhpcyBzZWVtcyB0byB3b3Jr
IGhlcmU6DQo+IA0KPiAgICAgICAgIEhBVkVfWFhIQVNIID0gJChzaGVsbCBwcmludGYgIiQocG91
bmQpaW5jbHVkZSA8eHhoYXNoLmg+XG5YWEgzX3N0YXRlX3QgKnN0YXRlO2ludCBtYWluKCkge30i
IHwgXA0KPiANCg0KWWVzLCB0aGUgYWJvdmUgbGluZSB3b3JrcyBpbiBteSBVYnVudHUgMjAuMDQg
YW5kIDI0LjA0IGVudmlyb25tZW50cy4NCkl0IHByb3Blcmx5IGRldGVjdHMgdGhlIHByZXNlbmNl
IGFuZCBhYnNlbmNlIG9mIHh4aGFzaCAwLjguIFNlZW1zIGxpa2UgYQ0KZ29vZCBzb2x1dGlvbiB0
byBtZS4NCg0KTWljaGFlbA0K

