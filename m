Return-Path: <live-patching+bounces-457-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3840F94B198
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 22:49:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B87E1C21A6A
	for <lists+live-patching@lfdr.de>; Wed,  7 Aug 2024 20:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE619145FED;
	Wed,  7 Aug 2024 20:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="G9bZH50B"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B89E13BACC;
	Wed,  7 Aug 2024 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063734; cv=fail; b=chmTSCe2gDiNsln/4nVpgArqXmfBIgIZnaEbFwsnFLj4aq5/4Ubv6rT2QPHXJMTQF0qK+8lZhoGU7iyQh04JskqMk45IKp9qpkeEuvB2R4itst/oNzXqhu44vnr18V1bl3Yt9Tvm7MgsyQmxpp2JAidRq1ij7HsHC4jhRtu5eBA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063734; c=relaxed/simple;
	bh=HxkdxS6yeeIiMlqvQm9hY82AxfC/GU7dIZwpG2S25kI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZQzzN3BiOzUfRjX8aBXrJLPHUEyAySSXyzZZoNX4lSnML/M04/ZzgKOzmXmslv+V5QnCP9zEkPSZlpdPFrFubj101k9d00cnJbM/Myx4znhkVTH5i6NA79bchsRfojxgv++ZDwM0Zbf3BuSr4pIgh8yA1mUPoqKNaTgHhHztd6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=G9bZH50B; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 477JKE2d031600;
	Wed, 7 Aug 2024 13:48:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=s2048-2021-q4; bh=HxkdxS6yeeIiMlqvQm9hY82AxfC/GU7dIZwpG2S25kI
	=; b=G9bZH50BoWRDGo9BHKGw/UDb+0DDsxFXbKsFC8TtXrewuo8TzRNVCtB2Mjt
	wedN8HZyVpVZ9h3uyllyu6BEN5ZcmGuLDV2sZ1UHB6b7zMqDmAC4mPFdCNn43SBW
	NCq20yCwAbMRjbJUNGTo4HhkUzsqOOfbQD71Q5szZQswatef44MQX/C3GUEU8Aq+
	Hl2i5Cxo0VCApIpFXnBIteRw94aXxBhzGwZwuQ+V4v3PyDFsX2T8Gx7PScaUJ/g3
	b5NGIQVp7hO9numKirgkwh3r0FJNc+qWwAbVVceQWBObB+yVFK9EOo2auarTW6SJ
	ACHjFZpTwWtgcVYwUsHuJ32OdVA==
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 40vb942fss-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Aug 2024 13:48:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQaV7eB1Fmyuuzaau/XwKvhA3vR+jRYNNMu6dhGFzO61IWBc/NGDcriT8SdEAvSxCg0aMfT2lB2KcozevBUsBZ/PXamChKwFCgUI/vO36Jm+0HsoX6WvXMj70h1orq0tRCZWEzPdAeBJmcUkqjIaoyKaapzwW3hZZtmHGGx3adKGaoZ4J9GhQ/2QEMvqu4k4Tm0sOaMRTHl3fiGiOn7hqgmLnLsuvj11wyMe2bNdggxo75QKed9PHYfBV4sSHSVyBnG5kojx8OR/CynbCj+rAZ6G6b0vVrS7coeTH7XqRRKyhOwoKzfZeCbn+r8buZlJqgqLuzuCCbLHmKwT0c9i+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxkdxS6yeeIiMlqvQm9hY82AxfC/GU7dIZwpG2S25kI=;
 b=i8gq/kK2crCHDzKwNb7jTU1gARUQmwoUFb8+7cz70NUKm33k9jHZDcigfdE7eu0hJmmBG6YvPMvIS1rpuNpTB5KR2GYvNxNNf3ybk+nKkqK2GUz9eMzvdPx9qan1fH8cnr3tdICC/z6fhgmrycmnU0EJk1ibXlV/cAzOr1YDC0b08EAZ2PSufbKU7pWTwYLKysf4TphkzamfEhsfsC3cs9OBr2WzOcj2N5620vlO1n6pZKhI6TXy7zRqsQqEozBtsQypDNieWIwNy4+yoSTPgHbIO9XOzHu01BE4POt3YDxMaL5wm7dWjSLCf0Bu2CjDEHEUh1T2RQzK8bN5ZlMjqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB6502.namprd15.prod.outlook.com (2603:10b6:510:30b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.24; Wed, 7 Aug
 2024 20:48:48 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 20:48:48 +0000
From: Song Liu <songliubraving@meta.com>
To: Sami Tolvanen <samitolvanen@google.com>
CC: Masami Hiramatsu <mhiramat@kernel.org>,
        Song Liu
	<songliubraving@meta.com>,
        Steven Rostedt <rostedt@goodmis.org>, Song Liu
	<song@kernel.org>,
        "live-patching@vger.kernel.org"
	<live-patching@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence
	<joe.lawrence@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "morbo@google.com" <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Leizhen <thunder.leizhen@huawei.com>,
        "kees@kernel.org" <kees@kernel.org>,
        Kernel Team <kernel-team@meta.com>,
        Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Topic: [PATCH v2 3/3] tracing/kprobes: Use APIs that matches symbols
 without .XXX suffix
Thread-Index:
 AQHa5SA8SXbfly1McU6eyK4ZRfeJlbIalxIAgAAOHYCAAAc6gIAAAEiAgAADDQCAAD/9AIAABNyAgACkkICAAFrMgIAAWCcA
Date: Wed, 7 Aug 2024 20:48:48 +0000
Message-ID: <09ED7762-A464-45FF-9062-9560C59F304E@fb.com>
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
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
In-Reply-To:
 <CABCJKucdMS1hkWjHWty8JyACjZy2R9juusABcbsMYzNej=pB2Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH7PR15MB6502:EE_
x-ms-office365-filtering-correlation-id: 946796e3-d1ed-4b20-413c-08dcb7225678
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|1800799024|366016|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VjFOeEZXK1hjT25iN0dyWUhienBSLzkrYTVYZ0c1R01vWWZuN3dQeDQ1NnQ0?=
 =?utf-8?B?ZzlvemdOVjlqSTMxWEpZRnhKS2cvRTYvcWRSN3RtMTNBMlQzM0x5TGZXQmFk?=
 =?utf-8?B?ZjZRMUE3Tk0vbHBZcGQ0bENmNzNZZ3pFRXdtVWYrU0l0YllKWG1PZFJDVFVk?=
 =?utf-8?B?aldoQWlzSXJXZnMzMFNHUThCQ1Q3MWtqdU5zVlZ4VGJkVXdYWmk0WUMxcHdT?=
 =?utf-8?B?RThUTlhjTlhWMTg1K2Z5cnFlaUxjSXFGaDRzdEVpR0F6RGtMb0ZRSUg1TllU?=
 =?utf-8?B?Nk8yemxMS3lCSndPTkNyUzRGTkNDblFKNEFnZzRYMXEwWU9QL1BJcm5McFp6?=
 =?utf-8?B?QW91cDZCVTk4bkdZVnpSb1h4TjZrNHVicW9FaldVMVROdzl5Y004U0xUSWt6?=
 =?utf-8?B?ZGcxeVJlZTYwNnVHNEJFWW5qb1JlczZWOVlnRmJzcG9tcXdva2xYa0RVaE5G?=
 =?utf-8?B?d3dJeGh6dzcvL1dKbWh4bVg3M3ZIeVpNWmZ4aklWUWIwOFppaVJZY0RsNUNq?=
 =?utf-8?B?a1QvNC81L1JEbkw3dHlOb3JnSG1WVWd6QUFvc3dnQktpTTJqelZObUFVUi9J?=
 =?utf-8?B?clJxckwzQ3dwanVzRmxiNFdNWHFXUlpZODhITjY2OW5wS0NXVisvbXpFcFNy?=
 =?utf-8?B?SEgxbWFCaDRrRUxmYlZiSnowb1JmUWxlZHRvUVkvTHhzSDNNaEZHMFhBUDBm?=
 =?utf-8?B?eFh1b3ZkSFRoY1VDQ05aUmgrcWhna2hUT0N6SG4rSDcxcmJlbEVSTDVYa1ZG?=
 =?utf-8?B?cWNHcndQWUppVldoUmNUS3RuL2k3ek5WOVJBYjR6SkxXOVhFSWUyT2hwYWFS?=
 =?utf-8?B?RDJOYVRyZVBlWTRURStJb01hVTdwZTlPSS92SWEvQnFFbGFZYnFheThhbEtk?=
 =?utf-8?B?Ymc3bEYvWmY5NTVJbjRMNDVNdllkVnJKVEs4Wnh2RDFpK20wSWJOQkFYNFNF?=
 =?utf-8?B?aWR1QXI5RGRhZVVhNDdsU1o5SlRodkhRTTBVYmlxamRpZE9RQ1l2b0tRck42?=
 =?utf-8?B?cFFnQklzUmNPTTBXRzR4MVdEV0p0QXpSUWZPRnpxWVk1czN2c21JdEVLTDhn?=
 =?utf-8?B?ZHI5VjlUdW8vS3VxTW5GN3dBTnJiTmViVjh6a2NxY29pZ0hzSnNFaksxeW1G?=
 =?utf-8?B?V0FuVjFFR0xpdlVhaVZYY2xySjlBN01aanRaRC9mS3JXVUJGSnJxWWREN2dB?=
 =?utf-8?B?N1R1em1RQzI1elpQanYwU3BjMVpKcGE2enNtWTkrU0FIemttM2IzOVVpRklC?=
 =?utf-8?B?YkU5RllGRFhlem1uUWNSNlJ3bHlleWczUi9UdFI5aFIrYlhUdU9MYnVYNmw3?=
 =?utf-8?B?ZGVyd2FQbG9oekQ1OGFPSHNSRmliWmtKZDJzQkQrQkZSenJRZVlqT2xtUHNt?=
 =?utf-8?B?Y0xhdm13cURUQjF4ellCemlzdXFNWG9Ua2ZmSlhzV2x4YXRhVTFrbXo0MnNQ?=
 =?utf-8?B?MDhxR1YvZTYrVUJWQ0p2UEQ4TlF0Mk5xVUtTT1BpbDV0UW96Q0ZMNHkxcmlG?=
 =?utf-8?B?bUZGc1lFQVFDak02ek43dmdTQ2pzZyt0c2lQUnhjV3ZKK1lVWmIrU25OeWlm?=
 =?utf-8?B?M0FSbWJ4YkpGcExucE16bDBYZTNqUzlScnVUL3dETHp2RkRoR3dtWmhERXYv?=
 =?utf-8?B?V2Q5cmk5ZDN6RFpSSFFBenBzTGZ3SnZ5cmtyaSs2cSt2aVpaRXdmT0pnSTdY?=
 =?utf-8?B?ZnRhcC8yUHluWVVxQ0pObmQyWWFxSGJsak4xMTRLMjhBVm11aVhiL3lTYkFK?=
 =?utf-8?B?eXo3TzVSTzVzWitCaEZrQUNBVFFZT3RJbFcxR3U1dHBXdU1kNFQ3eHZDWFUv?=
 =?utf-8?B?azZWNkFtYnZXTHRudy9tcmptZkwyMUh0UHpJMXgvdStycVh6NEh4Y2h1UkVv?=
 =?utf-8?B?LzN5NUlKd2lwdG1XUnNnVUhKZThhWU84R25kZHFOS0Z0N0E9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUpkS1c4TEtaa1huMkR4UTNUWlNsNCtrYWhYTldGcE9FenAxVUpqSlhtb3FX?=
 =?utf-8?B?aFArZGtTMlFldWJFUVdKMmwxdTNodnJwNjUzdi9BaDlhUGZIbWVadWdVMWFa?=
 =?utf-8?B?aFFMRFZ5KzRrc0VPQUp0ZkR0bXVvbG5wRzJ0VmVHSElkaU9JdmgyaU9QbEN6?=
 =?utf-8?B?YUtNNzVYL3Q5M2twaHdJa294eUhpdC83UkJ6Z2lnRHNhZml5NERTQ2ZTOFpL?=
 =?utf-8?B?YlUxRFNvZ29GdmNYSEE5aGxpaEx2dXQzVDZmYjRIbkljZURTMEdveWEzT1Vs?=
 =?utf-8?B?RFFLcUw4aVhGS0J2MkdvdmtRdEVGOExKU1Y4cmRib0ZGN2dFM0FwaW1RbDRi?=
 =?utf-8?B?UExxMVBBbDUzSk01bTVYUFdkeXdYaVo2QWR0eGFMcWc2ZXZLa3BqUkdEbk5z?=
 =?utf-8?B?bzRKNHdoQkhscGMzVDlpZ2Nhd0xoRlg2Ulg3QnZuZU1kMDVlOC9xRE1GNE5D?=
 =?utf-8?B?eE9SMlg1bEhrNFhjaCtXN3pMQUFyMnRDS3FIMFptK1M5MVJjZ3FlbWtDRlFu?=
 =?utf-8?B?aU9mZ1FYemR3bUlSN25SRUFrS1drdWFmZDBsSWVjd0RQOGNNZkcybFBMVko4?=
 =?utf-8?B?OExZZ2h5bDVSYlVEeTMvVHg1U1Q2MklnWHNub09LZzk4UFp0eG9naWtOeVM5?=
 =?utf-8?B?dzlXV1VMemVrY1NHMVhGcWdrZEpEMjBjU2M4eC9kVlNVa3FXNVp0eDgwN2ZH?=
 =?utf-8?B?NzU5Z014eHhpb2pNTnZBNUpGRzJlNTI0NC83dWl3cXZaei9pbzc2a0hCVnY5?=
 =?utf-8?B?RnRtK2xNMm9ERG1QTnhDbE9Pc2tXTjJkWm1KcEhwdTJDbjk0WVczTE1yT2tn?=
 =?utf-8?B?cnJsU1NaZWNDb29SMVJ0aW9ZNWxkQXhzRGNGZ2kvWVptSDkxSjFEUjVubjJR?=
 =?utf-8?B?WXVUd1VpUENreGx5aTJLVjBjWkpNQUpueTVkbzVlRVoxS3VkSjBTK2NRTmpU?=
 =?utf-8?B?Y2t1U3E4NlRHRGpTZzcwVExQTm1GMjJWajYwbjhMK2p4L240ZVQ0Zi84NUho?=
 =?utf-8?B?OCs4VDBTN0RqeHdaTVZvRmpmVUo3OXV5eXNuK3FWaENPZVBGa3VzQjc0ODI2?=
 =?utf-8?B?c3hVRkhEYTlSd1Y2SHpEZnB1MDZMUUVpcFNIcTRKVEFMcWVnQjBzYmpKbS9H?=
 =?utf-8?B?ckNkWXVReUhJNEw2TnZwemluY2tFQzlKYTVqZ0ZYenNCM0s0RVVVRTMzdlZm?=
 =?utf-8?B?WEZlNVlGYmxGM1RyTVJGZS8xaDNDd0prcGg0UkZhRWd4UE9hQWR6NGZYWjJL?=
 =?utf-8?B?ZWx4K2xVaU1TRkYzTk42YUdnNWt4b0lSZGZtV0JQQmQxOTB0KytjT1RQMUpp?=
 =?utf-8?B?Zndpb0JndlB3dVQ0VUNqdXRFcVpXVHRIYXYxMU1VSkJ2aGxyaDRSeVplTHFR?=
 =?utf-8?B?ZnBpZ1h3NG9vYlZBQ2tSQlIyQzM4UDdtWlVxNC8rbGFHS0NGTGRac2NsRUhn?=
 =?utf-8?B?QjBsOUJkcFo0R3FZL0pzL2IxVTh3OUJPbmp4cmo4Vy9OZUlrQlAwWklSclpi?=
 =?utf-8?B?SEJWN3liMmIwS25LcDhpL0Ruc3pLTGtyUGZlUGtDY0xzQjN2ZVBTbEhqNWF5?=
 =?utf-8?B?NXFORlFlSVRQT1VpZUZ5VktOLzRVWUw1US8zOXE1SEVCczhHeGhmYWtJZi96?=
 =?utf-8?B?NWhUZUhURVg1RmcwRE9DQWlLUXhxMGpNaFhMVDVEVFRIWnJCTjlXVloyMGs3?=
 =?utf-8?B?Zld3WVlPY0F4aDdQZ2hsR0RTaWUvRDJPNFczekUxZDV5cW9BZmZLbGFMZlVj?=
 =?utf-8?B?VUJEL3RKOUhuODhSMGxuN0tFUWdzSmVRSERWVThyb2xROEQrenVuSHhqb2Ey?=
 =?utf-8?B?RUFxQmpmem5kR2d3dzZqZWl3cXpXZFF0b3V2SUlzL3VtbFU2OGlhN1RsaXZX?=
 =?utf-8?B?L0NORGVxaE8xaDRpOWUwZ2hBQ25YNlZrOEoxRzE3bVc2NGRGYXFOQjhlRmo5?=
 =?utf-8?B?VEtlRkxwbDNUcGxRdXVuNktrOXcweGxseC85bVoyV3RHRk5JNjJUYnNKaVJ5?=
 =?utf-8?B?US8vcWswRXFSMkNwdmdjRXRqd0JGYmVQSWdSczdLZVFKRGdaVU5ZNFdXZDhF?=
 =?utf-8?B?aDNWZWFWYUtBL05Udms5M0FJMXc4OFBpVlB5eFdZSlVNTndHc2hsaXA5VTZy?=
 =?utf-8?B?Z1g5QmFBd0VUMmpnOEZ5dm5FbG9oajIxaFo3bHkxUEQzVmtPT1owc01BNjdV?=
 =?utf-8?Q?JcWHZVtwfvIxpq0DZ4K8SjE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B62011827A0E0F4CA8455AFDE6D4CFD7@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 946796e3-d1ed-4b20-413c-08dcb7225678
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 20:48:48.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rpjLUYZkTuxhWn7fG2+1d4vqmiSaJC+QMQBJCutsWIXsNfjZuIDagYKdc4ySP1F7utu2NI1L0Sq4xL953bnF6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB6502
X-Proofpoint-ORIG-GUID: ccc9NHUrzhCuhI7SFG2qXlFXh4kNiG5A
X-Proofpoint-GUID: ccc9NHUrzhCuhI7SFG2qXlFXh4kNiG5A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-07_11,2024-08-07_01,2024-05-17_01

DQoNCj4gT24gQXVnIDcsIDIwMjQsIGF0IDg6MzPigK9BTSwgU2FtaSBUb2x2YW5lbiA8c2FtaXRv
bHZhbmVuQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBPbiBXZWQsIEF1ZyA3
LCAyMDI0IGF0IDM6MDjigK9BTSBNYXNhbWkgSGlyYW1hdHN1IDxtaGlyYW1hdEBrZXJuZWwub3Jn
PiB3cm90ZToNCj4+IA0KPj4gT24gV2VkLCA3IEF1ZyAyMDI0IDAwOjE5OjIwICswMDAwDQo+PiBT
b25nIExpdSA8c29uZ2xpdWJyYXZpbmdAbWV0YS5jb20+IHdyb3RlOg0KPj4gDQo+Pj4gRG8geW91
IG1lYW4gd2UgZG8gbm90IHdhbnQgcGF0Y2ggMy8zLCBidXQgd291bGQgbGlrZSB0byBrZWVwIDEv
MyBhbmQgcGFydA0KPj4+IG9mIDIvMyAocmVtb3ZlIHRoZSBfd2l0aG91dF9zdWZmaXggQVBJcyk/
IElmIHRoaXMgaXMgdGhlIGNhc2UsIHdlIGFyZQ0KPj4+IHVuZG9pbmcgdGhlIGNoYW5nZSBieSBT
YW1pIGluIFsxXSwgYW5kIHRodXMgbWF5IGJyZWFrIHNvbWUgdHJhY2luZyB0b29scy4NCj4+IA0K
Pj4gV2hhdCB0cmFjaW5nIHRvb2xzIG1heSBiZSBicm9rZSBhbmQgd2h5Pw0KPiANCj4gVGhpcyB3
YXMgYSBmZXcgeWVhcnMgYWdvIHdoZW4gd2Ugd2VyZSBmaXJzdCBhZGRpbmcgTFRPIHN1cHBvcnQs
IGJ1dA0KPiB0aGUgdW5leHBlY3RlZCBzdWZmaXhlcyBpbiB0cmFjaW5nIG91dHB1dCBicm9rZSBz
eXN0cmFjZSBpbiBBbmRyb2lkLA0KPiBwcmVzdW1hYmx5IGJlY2F1c2UgdGhlIHRvb2xzIGV4cGVj
dGVkIHRvIGZpbmQgc3BlY2lmaWMgZnVuY3Rpb24gbmFtZXMNCj4gd2l0aG91dCBzdWZmaXhlcy4g
SSdtIG5vdCBzdXJlIGlmIHN5c3RyYWNlIHdvdWxkIHN0aWxsIGJlIGEgcHJvYmxlbQ0KPiB0b2Rh
eSwgYnV0IG90aGVyIHRvb2xzIG1pZ2h0IHN0aWxsIG1ha2UgYXNzdW1wdGlvbnMgYWJvdXQgdGhl
IGZ1bmN0aW9uDQo+IG5hbWUgZm9ybWF0LiBBdCB0aGUgdGltZSwgd2UgZGVjaWRlZCB0byBmaWx0
ZXIgb3V0IHRoZSBzdWZmaXhlcyBpbiBhbGwNCj4gdXNlciBzcGFjZSB2aXNpYmxlIG91dHB1dCB0
byBhdm9pZCB0aGVzZSBpc3N1ZXMuDQo+IA0KPj4gRm9yIHRoaXMgc3VmZml4IHByb2JsZW0sIEkg
d291bGQgbGlrZSB0byBhZGQgYW5vdGhlciBwYXRjaCB0byBhbGxvdyBwcm9iaW5nIG9uDQo+PiBz
dWZmaXhlZCBzeW1ib2xzLiAoSXQgc2VlbXMgc3VmZml4ZWQgc3ltYm9scyBhcmUgbm90IGF2YWls
YWJsZSBhdCB0aGlzIHBvaW50KQ0KPj4gDQo+PiBUaGUgcHJvYmxlbSBpcyB0aGF0IHRoZSBzdWZm
aXhlZCBzeW1ib2xzIG1heWJlIGEgInBhcnQiIG9mIHRoZSBvcmlnaW5hbCBmdW5jdGlvbiwNCj4+
IHRodXMgdXNlciBoYXMgdG8gY2FyZWZ1bGx5IHVzZSBpdC4NCj4+IA0KPj4+IA0KPj4+IFNhbWks
IGNvdWxkIHlvdSBwbGVhc2Ugc2hhcmUgeW91ciB0aG91Z2h0cyBvbiB0aGlzPw0KPj4gDQo+PiBT
YW1pLCBJIHdvdWxkIGxpa2UgdG8ga25vdyB3aGF0IHByb2JsZW0geW91IGhhdmUgb24ga3Byb2Jl
cy4NCj4gDQo+IFRoZSByZXBvcnRzIHdlIHJlY2VpdmVkIGJhY2sgdGhlbiB3ZXJlIGFib3V0IHJl
Z2lzdGVyaW5nIGtwcm9iZXMgZm9yDQo+IHN0YXRpYyBmdW5jdGlvbnMsIHdoaWNoIG9idmlvdXNs
eSBmYWlsZWQgaWYgdGhlIGNvbXBpbGVyIGFkZGVkIGENCj4gc3VmZml4IHRvIHRoZSBmdW5jdGlv
biBuYW1lLiBUaGlzIHdhcyBtb3JlIG9mIGEgcHJvYmxlbSB3aXRoIFRoaW5MVE8NCj4gYW5kIENs
YW5nIENGSSBhdCB0aGUgdGltZSBiZWNhdXNlIHRoZSBjb21waWxlciB1c2VkIHRvIHJlbmFtZSBf
YWxsXw0KPiBzdGF0aWMgZnVuY3Rpb25zLCBidXQgb25lIGNhbiBvYnZpb3VzbHkgcnVuIGludG8g
dGhlIHNhbWUgaXNzdWUgd2l0aA0KPiBqdXN0IExUTy4NCg0KSSB0aGluayBuZXdlciBMTFZNL2Ns
YW5nIG5vIGxvbmdlciBhZGQgc3VmZml4ZXMgdG8gYWxsIHN0YXRpYyBmdW5jdGlvbnMNCndpdGgg
TFRPIGFuZCBDRkkuIFNvIHRoaXMgbWF5IG5vdCBiZSBhIHJlYWwgaXNzdWUgYW55IG1vcmU/DQoN
CklmIHdlIHN0aWxsIG5lZWQgdG8gYWxsb3cgdHJhY2luZyB3aXRob3V0IHN1ZmZpeCwgSSB0aGlu
ayB0aGUgYXBwcm9hY2gNCmluIHRoaXMgcGF0Y2ggc2V0IGlzIGNvcnJlY3QgKHNvcnQgc3ltcyBi
YXNlZCBvbiBmdWxsIG5hbWUsIHJlbW92ZQ0Kc3VmZml4ZXMgaW4gc3BlY2lhbCBBUElzIGR1cmlu
ZyBsb29rdXApLiANCg0KVGhhbmtzLA0KU29uZw0KDQo=

