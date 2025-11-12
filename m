Return-Path: <live-patching+bounces-1834-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D82D8C50386
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 02:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7A1E91897797
	for <lists+live-patching@lfdr.de>; Wed, 12 Nov 2025 01:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 537CD2737E1;
	Wed, 12 Nov 2025 01:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="P8bdco4x"
X-Original-To: live-patching@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazolkn19010016.outbound.protection.outlook.com [52.103.20.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609AE2737F2;
	Wed, 12 Nov 2025 01:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.20.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762911577; cv=fail; b=DtUqOzD/E8fgVh2aBfARX+DNWkWGSNxYhkg+h4AORpnCt1wc+FF1cFR9cXhS/C1r/CTIK/nIj5a8hqA7kFINI4WQCOyCMuWxcYmd07N56VE1zTtfyNNloZjMjRx3KYcubyOhEMdB6ehaijRPx20oE6NxPxSyIdeW4azv+/ukMjc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762911577; c=relaxed/simple;
	bh=1Lsbw8Ent7KCFRnZM+kyss3hacr5KiYHD26zkOF+r98=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fpFXjzReoUZf6EDyaE3dNQrSBg75l/7haUfvx5NHgD9BQAqbichNhVRM+Q/emlW8WbNbTutn1bqd88VtIGTvERd0Mn+T8qBXWcycTmqXoDqxb3onAJSc4yahVJc4sA3j4QiEyNUofY7dYBgTINVxPNnxYuCsWL3OyCEqSCnwUKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=P8bdco4x; arc=fail smtp.client-ip=52.103.20.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=goIcgeLPLeGxvHmdY5dN0/egN9/gg3ujE4dCemJGjt6aQNtOiawQwgESASvWeC39STzwNFrZHQ+PUiA+tRFB8ob1ipl5SubIYTbvM4uPzGNE7dyPJ3//zbQZbfSN3jBblu5eTzyu6Vg4rgPuIFXVVpUjDdZ8X7KoHMBiYi8aYKJoxUJZsQBqI9sdvV6QoVT3IXlrI668ejuTTRuBZh+T5Q3EHMqh7wvc2FCZfvPWJHWte/ivXjuTgicBR0HrsC1s7JNIXh6T4YO3tQE7SWXxySXetQAxDXGS/zoM4cRZx/xmps/HysE01gnGlMQyXpisqPz9c0BahHlpqVrSeReo3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Lsbw8Ent7KCFRnZM+kyss3hacr5KiYHD26zkOF+r98=;
 b=SE/GdaJ3dAi7PDzRX/7yzhOQecd91fCqMO84eH1e6EcLZd/TFEn+5nqSjNIiUzUXRtZg6CqhldRWLomA3oyBmmnTWpgPGGN3k2vP+MwXwiwKhWfy8AJZHWkmvfwS4PhCP+YapnuB230KhauswoHPxEhOiRh89je3KgqgndLzkCYAbMBPsEFiMblmuEMOxZUPYr8vlr525dISoWLcycbwRhx2MX+VXmW5S2+C//Dyr4N3sFcmIuDoC7TDcW2QKZt4X9ZTrhBWv7S344g9AlmHhBCmpUWn0Bf5VujkFl+NxhpKd+iNI/tgalNUehZZpHBTuQo52fC0vEofgBIXQ6jQaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Lsbw8Ent7KCFRnZM+kyss3hacr5KiYHD26zkOF+r98=;
 b=P8bdco4xqnxh4U5S+8ENax+O+ZgdD7ae1ULgOJpDsvHzHTn6QjfTnR7RmDxOMa0L3vUr5UAU45VJxUo6DlTFsryNZJWzHfKNBXCeTDyLC2etb169IsiHeEGY7A5yONMOjJqbZl6Ko3z863WuxQMQMFstqylNvcmchqEeO9OWk80giVL49QeUDl3vjd6z05GYf6RXrHILw5sFBUqdIcjPDsT9lC+PFNglLOr8YvEc4B0MofZarweSdLWZfit8RJo3bWpTwYpOrw4nfy+EFxjeJoUnS9V2ynsk2BWpJ1NKo60Do9+XerLm5FEWJXk3/H8HEZJBFPxezPHZC0pRrjxJdA==
Received: from SN6PR02MB4157.namprd02.prod.outlook.com (2603:10b6:805:33::23)
 by PH0PR02MB8437.namprd02.prod.outlook.com (2603:10b6:510:10e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Wed, 12 Nov
 2025 01:39:27 +0000
Received: from SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df]) by SN6PR02MB4157.namprd02.prod.outlook.com
 ([fe80::cedd:1e64:8f61:b9df%2]) with mapi id 15.20.9298.015; Wed, 12 Nov 2025
 01:39:25 +0000
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
Thread-Index: AQHcJ+6qpEmfJskj+02bf6oIo51EqLTUFK6ggAK7zwCAAjZrQIAVN1sAgABS88A=
Date: Wed, 12 Nov 2025 01:39:24 +0000
Message-ID:
 <SN6PR02MB4157212C49D6A6E2AFE0CAA9D4CCA@SN6PR02MB4157.namprd02.prod.outlook.com>
References: <cover.1758067942.git.jpoimboe@kernel.org>
 <1bc263bd69b94314f7377614a76d271e620a4a94.1758067943.git.jpoimboe@kernel.org>
 <SN6PR02MB41579B83CD295C9FEE40EED6D4FCA@SN6PR02MB4157.namprd02.prod.outlook.com>
 <5an6r3jzuifkm2b7scmxv4u3suygr77apgue6zneelowbqyjzr@5g6mbczbyk5e>
 <SN6PR02MB41574AD398AD3DE26DB3D23BD4C5A@SN6PR02MB4157.namprd02.prod.outlook.com>
 <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
In-Reply-To: <6msqczigbcypeclqlgzgtqew7pddmuu6xxrjli2rna22hul5j4@rc6tyxme34rc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR02MB4157:EE_|PH0PR02MB8437:EE_
x-ms-office365-filtering-correlation-id: 8bc842e3-5da2-490e-05aa-08de218c4fa9
x-ms-exchange-slblob-mailprops:
 Cq7lScuPrnoyTIwSrGph0lItVprk4CpiAu/5+zMLEH96QXoPn59WNKJXPgiAH/HksUWNef3vIuswlb6DjQtjUstdV2HjgcaBfkSRa9mxL3eWGXlW+zwef/BQ52k0loJfCOyVEjMPABxkNTzysv4pT8YC7fCq/+h7iU/eic7JCRa6Ic3sU9ryw4W29n9xWk33PpcAGfJzPH2dE7aPcNtstSzPTfYukzpuXBiZ+4B4FujJVPoqGkGL3KPO5BEIYi17tQ4qi2NwSgN5IkmaQSf9P47NceSlUXYA0KJSjkctLIKQFg5p0LZdurAHSq9//XQ/IwFHFf4NRmCI/JKdLqBJ+WZjwGwwmoLIuOKS5X+hpBT+SVbl7xlxqjYB/SrL5fLB5cBcusLdRWonFLF8S823z70UF3BosscrBPUxHYSm8zObr2Xo44dwKloUV50Kbdeu/Nfj+ZtqghAlhYn5fVYkiZ19zk3eMJR+FF+p7mrt71GcXznPM64Lt+CUZwQ4pqnK66AqmB1WkNpJ2e2lJltnSrIlHl1i+FHZeWD8fMgH4FvTVQZszNTdltIBDkRnFDvBtiUQeTWgJIhrT+TNgAetahWStNlxV+7yNVYovvCIJMRubn3E8XklDLvhO4DM9fnu+vsOYcRajK7FmGOeop5nO+kZxIxJZcNJ80vVelzTreVvl2t6/wJcAX8KKcPSmx48ZtzZyrTIQxNKFhmWtj6qRTG9t6cYpku4K/43v6nt5Mb76acdCYzUwGqKE4QWiTTbY88cTdbLQ9Q=
x-microsoft-antispam:
 BCL:0;ARA:14566002|39105399006|461199028|31061999003|13091999003|8060799015|8062599012|10092599007|19110799012|15080799012|12121999013|3412199025|440099028|41105399003|40105399003|102099032;
x-microsoft-antispam-message-info:
 =?utf-8?B?MmdDYXFDc3daTStOdG5WbC8wY1F4ZFFDUGc3ekZsd2JDMlRhRVhXLzcxQUdQ?=
 =?utf-8?B?dDJ1YlBCd2o1bDZaLysxRkJPVkZzRzRKM0Z5T1FhdENkVkNhUS90eWV4c1po?=
 =?utf-8?B?M3k5RDNVRThnc0h1aGJaTmtGWWJlUkNQdGV6dzVhbzV2WjNFZVNhNUdMTURE?=
 =?utf-8?B?SjVaaTBrdmREaXNiNlh5VklSSk5nSVl3c0lvRldqZHpmYzNOeCtnYzl0MmM5?=
 =?utf-8?B?RTU4MmlkMXB5Z1hpb0x3d2l6L0NTSmNJcTVkenB6cWloanZEbTAwYXRETUlE?=
 =?utf-8?B?OEFnMGpSU3JkYnRieldlbTA5eHdWNGpkYmNRNDE4NGFCQS84MEpIOFlFclRF?=
 =?utf-8?B?UE81cGtFZ1FWQkhTNmlVbXFMWEtrR0E4aDFWREN3MDVuUllDZDNxUjFSK2Zk?=
 =?utf-8?B?dGpJa2ZUR1BzYURGK1RaRmFpZ1FuRVE5eGxnd1l0UjlWdHBIR3ZyUnR4ZlE4?=
 =?utf-8?B?QU9EbnJ6aStkWFV0WldNZkJ5L3FGMGFYU2tSVzdreHJqSUVyZGFaMEtWakJs?=
 =?utf-8?B?c05CVXQ1VzFaWEpVdFVGYXVoNVE2TmtLbXVCT3djdVhnUGJLM3pPMWsxeXdW?=
 =?utf-8?B?QU1PWkJsRC8zUmRSMnFta2dmeXUrcng3UmNqb2taV05xWU1EenducTFnRGlx?=
 =?utf-8?B?Sm1COGpSZHpqdzdqUHRxVUg2cHIyWThDNUN2M2k3WVJibGN5WmM1cVdmVC91?=
 =?utf-8?B?ellKeG9EZGM5dTJvN3ZMY2wxQUxBQU9MRXArOVNvRXBSRjA1OFZqQ2ZrM09x?=
 =?utf-8?B?OWtrc1A1NVVwY3JnQTc5Y3l6bVJuekorRGFzandYazVWNkM2RUE4aXZvZExZ?=
 =?utf-8?B?eU1adEFDYm9rOUlXaEVYbmdzTzQ5OTZyM1ZsSmEvdkdFcDYrNk9ENUMybUZo?=
 =?utf-8?B?OXRHeEt3NEVhTldUVkVWTEJLam1UaFJLUnVsQTc2ZW5VSjJtdGNjTDBsWjZv?=
 =?utf-8?B?Vi81WUJ0NXBncFMydFA5TEZwRE42NFYydHNWaFNqRm04M2tOMzFyVnFjRlpk?=
 =?utf-8?B?d24wbnJRTlVyMmMxT0lMRFRMckpkT0FZcDkvNCtLU1NZQzJHK0Z3N3VjVjNZ?=
 =?utf-8?B?ejgzOVVaV3FEeFZ5Q3NJN2RXN1JqK2hIa2lVWEJmd3RzUWVYMExsTEkxTUZ0?=
 =?utf-8?B?cFZyOFQ4bXl5U2tONVJkdVkrRXF6VXZSdDFEU1dud1l3SThueWlrSSs1bjVW?=
 =?utf-8?B?dUY4Z0dTNXY0MWlaK2orSlR4S2t6aVhJeG0zSndXR0dLVGFQaUNWVkFGcVc4?=
 =?utf-8?B?RElramNPamd2dEsxVTUxdVZhaE1NVTg2cFh3NnFCeGFBWUpWV1FscTU0R2lV?=
 =?utf-8?B?MlgyZWUvMC9EV2p2RFZ0bGdNYXpqZ3dwNUxXczV3emdYVXk5MjJhek91SkVH?=
 =?utf-8?B?Q2VxcUQwWlRNd2VQV1c0eUQyeGwvOHRzWk10RXU3REtyMHJsQzhvUklzMzlS?=
 =?utf-8?B?TWdmWUE4UC9XaVFvV0RlbkxHWHZTZDBsNitraWJ1Z0FUU01ldlJpNzgzME5F?=
 =?utf-8?B?VHMrZGMyNXdsN09UOFlNcldkWWRJTVJ6cEZKV3Fndk54TGFra0ZhTDl0ZTNj?=
 =?utf-8?B?ZGExOGNSQ2V0MHZiWDJXOUViZW9UalRlRjVEa1hEenBETUZMK2o2bTZGTVNX?=
 =?utf-8?B?ckJPa0VKcGZ5aGlYKzVsVzJ2WDB6TnBTQUNMc1l6RjRpWStJYUpFQzZIMkZt?=
 =?utf-8?B?TDQyaWYrajBaanVzUk1VMW45QWhvQ1JGSHBNaUhmNHh6MlkzanEzNnJDSVJP?=
 =?utf-8?Q?/SUXTrbGNfU02RvU7yFi9+2CIQzKH5RCh8oOapJ?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?RUtlYndOYXpKZ1ZNUzIzRmNXSm45VFZNNVNtTmxaMjZIOVVRUmM1YzNIalBZ?=
 =?utf-8?B?a2dpeVBZR0xXT2MvYkE5dkh6TUE5NExSU2FVWnFTd2FndHJrU3g2aTVyZUZV?=
 =?utf-8?B?UXBRN1RtYi91TEVRdUFkU25DMERtSVVOdXY1SXdIQTZLdzRjK29naVMwQmZK?=
 =?utf-8?B?TGpOTFlQSTVDUks4cGRVSG9aYlBBSVRPbHoxS1pENE1RY2lhNEVqTzNlc0lP?=
 =?utf-8?B?S1AwOEp5TFp1b3VaSlZJYWhvbURNRUYzdko4V0ZDazBNdS83blk5ZGdTVkE4?=
 =?utf-8?B?SzUvb1lBaWJrL3V3d1hGdG5YVE9nWmR5STRpRXVPQ0ExSXF0NVl2eDIvN0Vt?=
 =?utf-8?B?ajNUS2FoU08yQjc5VlZKRmxzM1pZcG11Slo5TUFIcnZmN1kxbXlJNmNSTWtF?=
 =?utf-8?B?T2JsaFkvNGtnMFdKMWpCYlJIQVdob0VER0tXeGpNdTYxS0FHODBVR05SY08w?=
 =?utf-8?B?RzFpSTlySTVsU0tVNForbGtQekVuVitRT01rdU14Z1hXa3RSa0ZpVlR4TW1H?=
 =?utf-8?B?ZXN2QU1rOUx2L296Z0c5NG1QM3MzWnJtcGdIQmN6dmEveWVDU2FPN0JFRkRD?=
 =?utf-8?B?Y3pJV2VEaFRsM3IxQkIyNjZDb2JYY0IvWjlQdXdtclRydVkyTnNkRWQ5c0lt?=
 =?utf-8?B?LzZoaytveXUwTWc5WXowQTZja2R4UzlacCswUHltaTlPNi9jQUpycnhKY3Vw?=
 =?utf-8?B?R05ORUhReTZXZ3diTEo2VlYyQmJaekh6bTBDaWJLSVBkRVlNNUY3RzYwUUFN?=
 =?utf-8?B?U3htVDNiQWRUN3RjeGdCdDhkMWJyaXpReHZEN29qQlliWWtRZ3l0aytiUVZJ?=
 =?utf-8?B?Z3pqK1gvbVlLK3ZtdWpEdGNsenNibmxmQXA0M1NqVnpGVkltZzBpMVg5WTQr?=
 =?utf-8?B?SnNucVhIOUxWK0pROW53Qmk0MFM2Y2VCQjNBRzRRQUk1TzFZNkNjdW45Zkti?=
 =?utf-8?B?MUc5YlZIODVJMnhFYmV6aC9zKzhvR2VLNCtsRXBMSUs2TkJWbmU1UTZhQmhl?=
 =?utf-8?B?TytUODg2NFh1T2wyTy9GZVJwUXFOUTlRRm9TK0VYUUJsUlpyWW81UmY4aGhH?=
 =?utf-8?B?UjdUdmlvWFVYd3B3eFZkR3JVOFRBeUZTaFA5Nkd2T1oyZUVUWXYrTmovZk1I?=
 =?utf-8?B?cktadWZPME9hb2gvVE9FaVhtQ0U0TXVEUC8wQUZEcVEwMmlVejBjVmhLaWUy?=
 =?utf-8?B?MmxrRi9IakFkL1EwcUdUdENqbGdBdVRXOG9CU3g2aGhiVVVYc2s3MXRDbzUv?=
 =?utf-8?B?QkR6WEUzQkNLblJ2VXBOZjRYc2dEMGF6ZHJkcnhjdmxzNHV0bm5NNmFyS1FI?=
 =?utf-8?B?L3dWZmdRa3lhc2VIM2FRYzlId2dCZVNHa1EvY25nWXBKVU9wUU9Lb0VzRjFo?=
 =?utf-8?B?dVZvOFE0YllUeWJJODdjSnRrTXE0LzhMQlhGKysvTFJKYVJrQmVvSG96Nkpp?=
 =?utf-8?B?ZmoreU5hUjlTQWdGeFFrQll6OFpNT3BuS2dHTUF0ZEUyOUFQbVp6MGFaeGcr?=
 =?utf-8?B?QmZoUEFFS0pzc2JGVXZXQnZQZkthQVA5NnRFemM3SnRzOWhDamh2Zkl6YVd3?=
 =?utf-8?B?M0hURFFpcVFHRm1TSmdYcHRzQnR1M3lmZDBsTUplMUwzSlA5S2w2cFA2dVhp?=
 =?utf-8?Q?ICagSiY7Z07e0ajmqDQ+CQN11Yam3v8p9PNzXexDsgRg=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bc842e3-5da2-490e-05aa-08de218c4fa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 01:39:24.8259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8437

RnJvbTogSm9zaCBQb2ltYm9ldWYgPGpwb2ltYm9lQGtlcm5lbC5vcmc+IFNlbnQ6IFR1ZXNkYXks
IE5vdmVtYmVyIDExLCAyMDI1IDEyOjA5IFBNDQo+IA0KPiBPbiBXZWQsIE5vdiAwNSwgMjAyNSBh
dCAwMzoyMjo1OFBNICswMDAwLCBNaWNoYWVsIEtlbGxleSB3cm90ZToNCj4gPiA+IFRoYW5rcyBm
b3IgcmVwb3J0aW5nIHRoYXQuICBJIHN1cHBvc2Ugc29tZXRoaW5nIGxpa2UgdGhlIGJlbG93IHdv
dWxkIHdvcms/DQo+ID4gPg0KPiA+ID4gVGhvdWdoLCBtYXliZSB0aGUgbWlzc2luZyB4eGhhc2gg
c2hvdWxkbid0IGZhaWwgdGhlIGJ1aWxkIGF0IGFsbC4gIEl0J3MNCj4gPiA+IHJlYWxseSBvbmx5
IG5lZWRlZCBmb3IgcGVvcGxlIHdobyBhcmUgYWN0dWFsbHkgdHJ5aW5nIHRvIHJ1biBrbHAtYnVp
bGQuDQo+ID4gPiBJIG1heSBsb29rIGF0IGltcHJvdmluZyB0aGF0Lg0KPiA+DQo+ID4gWWVzLCB0
aGF0IHdvdWxkIHByb2JhYmx5IGJlIGJldHRlci4NCj4gPg0KPiA+ID4NCj4gPiA+IGRpZmYgLS1n
aXQgYS90b29scy9vYmp0b29sL01ha2VmaWxlIGIvdG9vbHMvb2JqdG9vbC9NYWtlZmlsZQ0KPiA+
ID4gaW5kZXggNDg5MjhjOWJlYmVmMS4uOGI5NTE2NmIzMTYwMiAxMDA2NDQNCj4gPiA+IC0tLSBh
L3Rvb2xzL29ianRvb2wvTWFrZWZpbGUNCj4gPiA+ICsrKyBiL3Rvb2xzL29ianRvb2wvTWFrZWZp
bGUNCj4gPiA+IEBAIC0xMiw3ICsxMiw3IEBAIGlmZXEgKCQoU1JDQVJDSCksbG9vbmdhcmNoKQ0K
PiA+ID4gIGVuZGlmDQo+ID4gPg0KPiA+ID4gIGlmZXEgKCQoQVJDSF9IQVNfS0xQKSx5KQ0KPiA+
ID4gLQlIQVZFX1hYSEFTSCA9ICQoc2hlbGwgZWNobyAiaW50IG1haW4oKSB7fSIgfCBcDQo+ID4g
PiArCUhBVkVfWFhIQVNIID0gJChzaGVsbCBlY2hvIC1lICIjaW5jbHVkZSA8eHhoYXNoLmg+XG5Y
WEgzX3N0YXRlX3QgKnN0YXRlO2ludCBtYWluKCkge30iIHwgXA0KPiA+ID4gIAkJICAgICAgJChI
T1NUQ0MpIC14YyAtIC1vIC9kZXYvbnVsbCAtbHh4aGFzaCAyPiAvZGV2L251bGwgJiYgZWNobyB5
IHx8IGVjaG8gbikNCj4gPiA+ICAJaWZlcSAoJChIQVZFX1hYSEFTSCkseSkNCj4gPiA+ICAJCUJV
SUxEX0tMUAkgOj0geQ0KPiA+DQo+ID4gSW5kZWVkIHRoaXMgaXMgd2hhdCBJIGhhZCBpbiBtaW5k
IGZvciB0aGUgZW5oYW5jZWQgY2hlY2suIEJ1dCB0aGUgYWJvdmUNCj4gPiBnZXRzIGEgc3ludGF4
IGVycm9yOg0KPiA+DQo+ID4gTWFrZWZpbGU6MTU6ICoqKiB1bnRlcm1pbmF0ZWQgY2FsbCB0byBm
dW5jdGlvbiAnc2hlbGwnOiBtaXNzaW5nICcpJy4gIFN0b3AuDQo+ID4gbWFrZVs0XTogKioqIFtN
YWtlZmlsZTo3Mzogb2JqdG9vbF0gRXJyb3IgMg0KPiA+DQo+ID4gQXMgYSBkZWJ1Z2dpbmcgZXhw
ZXJpbWVudCwgYWRkaW5nIG9ubHkgdGhlIC1lIG9wdGlvbiB0byB0aGUgZXhpc3RpbmcgY29kZQ0K
PiA+IGxpa2UgdGhpcyBzaG91bGRuJ3QgYWZmZWN0IGFueXRoaW5nLA0KPiA+DQo+ID4gCUhBVkVf
WFhIQVNIID0gJChzaGVsbCBlY2hvIC1lICJpbnQgbWFpbigpIHt9IiB8IFwNCj4gPg0KPiA+IGJ1
dCBpdCBjYXVzZXMgSEFWRV9YWEhBU0ggdG8gYWx3YXlzIGJlICduJyBldmVuIGlmIHRoZSB4eGhh
c2ggbGlicmFyeQ0KPiA+IGlzIHByZXNlbnQuIFNvIHRoZSAtZSBvcHRpb24gaXMgc29tZWhvdyBm
b3VsaW5nIHRoaW5ncyB1cC4NCj4gPg0KPiA+IFJ1bm5pbmcgdGhlIGVxdWl2YWxlbnQgaW50ZXJh
Y3RpdmVseSBhdCBhICdiYXNoJyBwcm9tcHQgd29ya3MgYXMgZXhwZWN0ZWQuDQo+ID4gQW5kIHlv
dXIgcHJvcG9zZWQgcGF0Y2ggd29ya3MgY29ycmVjdGx5IGluIGFuIGludGVyYWN0aXZlIGJhc2gu
IFNvDQo+ID4gc29tZXRoaW5nIHdlaXJkIGlzIGhhcHBlbmluZyBpbiB0aGUgY29udGV4dCBvZiBt
YWtlJ3Mgc2hlbGwgZnVuY3Rpb24sDQo+ID4gYW5kIEkgaGF2ZW4ndCBiZWVuIGFibGUgdG8gZmln
dXJlIG91dCB3aGF0IGl0IGlzLg0KPiA+DQo+ID4gRG8geW91IGdldCB0aGUgc2FtZSBmYWlsdXJl
cz8gT3IgaXMgdGhpcyBzb21lIGtpbmQgb2YgcHJvYmxlbSB3aXRoDQo+ID4gbXkgZW52aXJvbm1l
bnQ/ICBJJ3ZlIGdvdCBHTlUgbWFrZSB2ZXJzaW9uIDQuMi4xLg0KPiANCj4gVGhhdCdzIHdlaXJk
LCBpdCBidWlsZHMgZmluZSBmb3IgbWUuICBJIGhhdmUgR05VIG1ha2UgNC40LjEuDQoNCkkndmUg
YmVlbiBhYmxlIHRvIGRlYnVnIHRoaXMuICBUd28gcHJvYmxlbXM6DQoNCjEpIE9uIFVidW50dSAo
Ym90aCAyMC4wNCBhbmQgMjQuMDQpLCAvYmluL3NoIGFuZCAvdXNyL2Jpbi9zaCBhcmUgc3ltbGlu
a3MNCnRvICJkYXNoIiAobm90ICJiYXNoIikuIFNvIHRoZSAic2hlbGwiIGNvbW1hbmQgaW4gIm1h
a2UiIGludm9rZXMgZGFzaC4gVGhlDQptYW4gcGFnZSBmb3IgZGFzaCBzaG93cyB0aGF0IHRoZSBi
dWlsdC1pbiBlY2hvIGNvbW1hbmQgYWNjZXB0cyBvbmx5IC1uIGFzDQphbiBvcHRpb24uIFRoZSAt
ZSBiZWhhdmlvciBvZiBwcm9jZXNzaW5nICJcbiIgYW5kIHNpbWlsYXIgc2VxdWVuY2VzIGlzIGFs
d2F5cw0KZW5hYmxlZC4gU28gb24gbXkgVWJ1bnR1IHN5c3RlbXMsIHRoZSAiLWUiIGlzIGlnbm9y
ZWQgYnkgZWNobyBhbmQgYmVjb21lcw0KcGFydCBvZiB0aGUgQyBzb3VyY2UgY29kZSBzZW50IHRv
IGdjYywgYW5kIG9mIGNvdXJzZSBpdCBiYXJmcy4gRHJvcHBpbmcgdGhlIC1lDQptYWtlcyBpdCB3
b3JrIGZvciBtZSAoYW5kIHRoZSBcbiBpcyBoYW5kbGVkIGNvcnJlY3RseSksIGJ1dCB0aGF0IG1p
Z2h0IG5vdCB3b3JrDQp3aXRoIG90aGVyIHNoZWxscy4gVXNpbmcgIi9iaW4vZWNobyIgd2l0aCB0
aGUgLWUgc29sdmVzIHRoZSBwcm9ibGVtIGluIGEgbW9yZQ0KY29tcGF0aWJsZSB3YXkgYWNyb3Nz
IGRpZmZlcmVudCBzaGVsbHMuDQoNCjIpIFdpdGggbWFrZSB2NC4yLjEgb24gbXkgVWJ1bnR1IDIw
LjA0IHN5c3RlbSwgdGhlICIjIiBjaGFyYWN0ZXIgaW4gdGhlDQoiI2luY2x1ZGUiIGFkZGVkIHRv
IHRoZSBlY2hvIGNvbW1hbmQgaXMgcHJvYmxlbWF0aWMuICJtYWtlIiBzZWVtcyB0byBiZQ0KdHJl
YXRpbmcgaXQgYXMgYSBjb21tZW50IGNoYXJhY3RlciwgdGhvdWdoIEknbSBub3QgMTAwJSBzdXJl
IG9mIHRoYXQNCmludGVycHJldGF0aW9uLiBSZWdhcmRsZXNzLCB0aGUgIiMiIGNhdXNlcyBhIHN5
bnRheCBlcnJvciBpbiB0aGUgIm1ha2UiIHNoZWxsDQpjb21tYW5kLiBBZGRpbmcgYSBiYWNrc2xh
c2ggYmVmb3JlIHRoZSAiIyIgc29sdmVzIHRoYXQgcHJvYmxlbS4gT24gYW4gVWJ1bnR1DQoyNC4w
NCBzeXN0ZW0gd2l0aCBtYWtlIHY0LjMsIHRoZSAiIyIgZG9lcyBub3QgY2F1c2UgYW55IHByb2Js
ZW1zLiAoSSB0cmllZCB0byBwdXQNCm1ha2UgNC4zIG9uIG15IFVidW50dSAyMC4wNCBzeXN0ZW0s
IGJ1dCByYW4gaW50byBsaWJyYXJ5IGNvbXBhdGliaWxpdHkgcHJvYmxlbXMNCnNvIEkgd2FzbuKA
mXQgYWJsZSB0byBkZWZpbml0aXZlbHkgY29uZmlybSB0aGF0IGl0IGlzIHRoZSBtYWtlIHZlcnNp
b24gdGhhdCBjaGFuZ2VzIHRoZQ0KaGFuZGxpbmcgb2YgdGhlICIjIikuIFVuZm9ydHVuYXRlbHks
IGFkZGluZyB0aGUgYmFja3NsYXNoIGJlZm9yZSB0aGUgIyBkb2VzICpub3QqDQp3b3JrIHdpdGgg
bWFrZSB2NC4zLiBUaGUgYmFja3NsYXNoIGJlY29tZXMgcGFydCBvZiB0aGUgQyBzb3VyY2UgY29k
ZSBzZW50IHRvDQpnY2MsIHdoaWNoIGJhcmZzLiBJIGRvbid0IGltbWVkaWF0ZWx5IGhhdmUgYSBz
dWdnZXN0aW9uIG9uIGhvdyB0byByZXNvbHZlIHRoaXMNCmluIGEgd2F5IHRoYXQgaXMgY29tcGF0
aWJsZSBhY3Jvc3MgbWFrZSB2ZXJzaW9ucy4NCg0KV2hhdCBhIG1lc3MuDQoNCk1pY2hhZWwNCg==

