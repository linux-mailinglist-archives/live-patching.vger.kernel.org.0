Return-Path: <live-patching+bounces-1821-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C2975C0F8C0
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 18:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA96119A51C0
	for <lists+live-patching@lfdr.de>; Mon, 27 Oct 2025 17:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959F8315D4E;
	Mon, 27 Oct 2025 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="JdwsDTl8"
X-Original-To: live-patching@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF8F231354E;
	Mon, 27 Oct 2025 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761585031; cv=fail; b=Ut2m3q4F80WfmgV5pYXSiL2Vx8BkDgrXu3EAN4dwNGzXtAfdcvHhdJhuIEwQ1T9b6/89C6C6tCCMgB4Zo9H5dlJerTO2Yh1F4k+isuWqJuvBaNZ54SnIdSq0cog2XmUn/+tI6FeQ5+VsSwOfF8mOaghA+5Escbj1lmoYYcfdJ2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761585031; c=relaxed/simple;
	bh=AdbvxgTZUYslmmAPIsrf4DMBlCNbgAydKC0M3JVr2R8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kuqMO0TZpr3rXELAbfcdpH0eCmaSsBOD6qzHGlirfFvEZNBTzKcimRjMDLObUzMQXB+tm6NoYrSsiroptyvQMHqPjSi9YyT+JolgoyomlrBkfsu3ElQ31GeWpHTyUfG9YvI5AomVMGrHbvK8PWuscUReQsk+6YWbRkNprBuzhsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=JdwsDTl8; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59REkQxt3589596;
	Mon, 27 Oct 2025 10:10:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	s2048-2025-q2; bh=AdbvxgTZUYslmmAPIsrf4DMBlCNbgAydKC0M3JVr2R8=; b=
	JdwsDTl8dvowLhpg+tBmJ+RQgdLcDHVaw+0XGKR8+aaMcu3FmnlI/dpidm+EnGLQ
	Qu2YGxBIy+iMjr5HuiXP1fWxWRsXmSWvAmtobdFZfngJQXwckzaBNIVH6m0MN1wo
	DMhhFf3xJaJHzurqr0SMqKlGe+vb52h8MZ/SOwNEdDg/JIBA3Ah/3l6A1quld0iZ
	zw9VDT096LyFwEvnjlUkIPkBL3efkwbXL3y0rh6VTRnXDi/ZeiXBxU8/zT36YPDz
	c+vHKmqv0aoVfSLiNrHi87NbMBHgJ9fcepxNxtGDcSawfwn1DBNzjjdOvyDemBTI
	7cXwdtT4hdrJc0EG2aCmZw==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010026.outbound.protection.outlook.com [52.101.56.26])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a2aswhcxq-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 27 Oct 2025 10:10:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wjt0gMxXmRBA8gNlnVQ5frPPgsvqrMKl8Jz8DX+ODycz8lkcKERDWupsb8ldKDJOPG9Zw5ycKnH2AWISThEolyXiSa3y9uwsDCKQH+8OhpL8RPkxP6GBScxE8rZGvkpsZwyiYzFtk9q5Q0im8CvbioexO7wCm+Ez54kpXbVjNf4pZ+E2b/eQ1xcXIFHQkW1eYZxrQZWi8p4nSsQ2zb5/BRD0wy0yTkvOrdW3MHmxt6oyNz+NnyeBlG9u9UOipNFredLhENXNY3MMWsLbGo2lmwTFkjs2W57+Kk6EWLbPCi9e6IIJbLfwjtTxO3LTiTo0hyVa+SXnre4iftLVL+8GBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdbvxgTZUYslmmAPIsrf4DMBlCNbgAydKC0M3JVr2R8=;
 b=w6pFOo48W4/t9BPaooR8q3pnui8SMBPyY/R4bLcdv+OgQaIgCGiqJqXgdjEa1U0Qcq5P/ClKEumEVmE/aWBym8F6E1+xHk+uyvPCXW5klOKArum0E2m/H957Yr+oto95XrmYow70dyDN/rXTaqaaVy7J2MYhGB14g6ZWo0xg7IZ6mqHCXy6gWdFMvYyJvZynWXh9pYn+odL3xe5dTxryECC7F+LzW/+3v3KJBl7kKbXo/eG+TY0voXM9d/1a0G15ije8trsoAE1D4x7xwysdLSRo01u7Y+qH12WdhzhmZhmCQUjlB7M3m9eFIdnlRiYMy2R/EeTkk/ISnEHfaMvtNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4976.namprd15.prod.outlook.com (2603:10b6:510:cb::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Mon, 27 Oct
 2025 17:10:25 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 17:10:25 +0000
From: Song Liu <songliubraving@meta.com>
To: Jiri Olsa <olsajiri@gmail.com>
CC: Song Liu <song@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net"
	<daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "andrey.grodzovsky@crowdstrike.com" <andrey.grodzovsky@crowdstrike.com>,
        "mhiramat@kernel.org" <mhiramat@kernel.org>,
        Kernel Team
	<kernel-team@meta.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Topic: [PATCH v3 bpf 1/3] ftrace: Fix BPF fexit with livepatch
Thread-Index: AQHcRrrMbVQld49egUuB0IkrNG9bN7TVr3SAgACMNAA=
Date: Mon, 27 Oct 2025 17:10:25 +0000
Message-ID: <B3EEEAED-ABC5-4E42-8C1F-33BD0B085A40@meta.com>
References: <20251026205445.1639632-1-song@kernel.org>
 <20251026205445.1639632-2-song@kernel.org> <aP8x2VthUhZf4QVv@krava>
In-Reply-To: <aP8x2VthUhZf4QVv@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4976:EE_
x-ms-office365-filtering-correlation-id: b16f4c2a-48ab-4b43-25cf-08de157bb870
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?S0N2VDJvTGExV1dpUHJ5djUvalBlMXNIdm1mS3UxangxSUdJUlREQ3hGZytk?=
 =?utf-8?B?dFVXVldRRnArRkZlNjMyRkFCOXRGeHgzUkZYekZBUFB6ZC95UGxrL093aTBK?=
 =?utf-8?B?SklkMEN4cDlValJqUlczRER2NE80d205bjNPVm9sVTA0NkhNdjVNT1VSd3dH?=
 =?utf-8?B?SmlSZ3pzSThXNzZsYjNOOUlxcjZDcGZWVGlXaVBXWU1JdGgybDdMbUloRTZ1?=
 =?utf-8?B?RkJ1MFhsZWxjZXB6TitzQllDbGwvNU42SjhuL1dDaTZpV1ZQSzFudjJpSjNJ?=
 =?utf-8?B?ZXFXSlcxRk9lOHc1U3JUQ2VqZ3o3UEcwSFlhbTNjeStjbjJUQnpVQ1BnY3lE?=
 =?utf-8?B?ck5kc3BaQU4zYXh4aVNTZGRPazJRTCtpS0FzN2VxeHlIUC9xSTZtRzIyMjA4?=
 =?utf-8?B?NFlCRGNQMUM5WERzdFBOTjNpUFRmQ0Z1VTFPWWxGSE95b1B2SGhxaVRuR2dy?=
 =?utf-8?B?aytoM0JLa2RxMlg5SVNYYkVtWjlUU3pxTWFzUWsraXNvWmdHSG9NNlNmb0Rl?=
 =?utf-8?B?Q2VLc05HN1VwZmRmR3hiN09QdHdTSVo2WExxQWV2c3JOUHBKYXZzdG4wbGho?=
 =?utf-8?B?QVREb2RlYzlJRWFBUlBubllmSU1qZUhmZmdwcTlVNy9JM2YxR0l6K1JMUUUx?=
 =?utf-8?B?SzQzZVpISnNYU3FMNTdBaTFmeVREbXBITDRIdXJmVXJWOVlBME8za0xjKzd6?=
 =?utf-8?B?Q29GbUhFMzZDMklnYXc2bDdhbnBxMmpSR3dWbUkvV1ZEWHk2VkZmNDIweGpX?=
 =?utf-8?B?NFhkdWdRN0lMYmlSck5qRCt2cE1hSk9qcE5JMWZIeHplZGZVK0pnU2dLVWdw?=
 =?utf-8?B?UGZ2Z1QzVFN4NlRJbWtHN29BV2R4WVdMa0Q2QTdCZUVqYUhBd0ZycWJQVzJV?=
 =?utf-8?B?MG9CMTFFb3g2My82NUthemk0amxRdStCZXNZdy82cTY0akRjemlkTEJLUUQy?=
 =?utf-8?B?QitXcVJGZGVNanVkem5POXc4cjRmNW44ZnExYnNrY1N4UlBCa0dyQ29sMzBU?=
 =?utf-8?B?TCtlRXNIUXowNHpNRC9SRndCZ0RIOFlSSzc2OVZVbk9odzdxNUd0VFpTdnZi?=
 =?utf-8?B?ZjNaMVAxL3czZnhuaGs3MVhIZ1ZZdGVoQVFxeTBDbEl0alI2NUU2T00rYVBP?=
 =?utf-8?B?a09GcHRaQzl1bjZHSEh6c29ZRzc5eE15aGtpU2tRQXZMSkRXZXdxYU13K1I2?=
 =?utf-8?B?b0gvdGxBQVBrSGxZNWJjS2RXbjl3VW1WMkNvWDNOSWUyRnBzUGgwMmxCeDYw?=
 =?utf-8?B?R3F4NDhYRDQ0SDJxLzU0a3lmaXRhVkVVSTAwc1FDdklPZTZaeC9IMmNvT0FR?=
 =?utf-8?B?ekI5Ti9lWURnUTZFeTJvNTduMVFxSU1TcmQ4bjZldzk5cS9KV2JiR0YrbHBy?=
 =?utf-8?B?WkJrKytMY09PcUliSDBVWVNYL1FhQjhrMUVINlhWMDl1a0IwNTJ6bnJ4SXNj?=
 =?utf-8?B?Y2FFQmRFRUtucEwvSzloL1h4b215cUw3RWhCSTY0dENPZXNHTTdQYWloTXIz?=
 =?utf-8?B?N2REUWx3MlBHTms3VVVDNk1SKzlvMzBnU2ZPZFdrVjk1Rm5PZk14dDU5RzNq?=
 =?utf-8?B?UDY3SUxZd2JDekJLekRwQjB1QVpid2hESjNMVUhDR3VFMVkvbU0rdHZGRnlP?=
 =?utf-8?B?WXZtU3k5bGllajZoNUhXaFdSRXB0QlMzaHV4TDlwTmphbTBNMDNNdCsrYmo3?=
 =?utf-8?B?eXdaRHhVR3R0SVU2VXJ2QmRRVjNmQkpNUFZydWMvd012MWxtQSszczhLMjRM?=
 =?utf-8?B?TmFtMnU2WUFnSFpidVJKUitYZjM1dlhlUzgrdzdMQnBFQy9XRTFnTEQ4Z2Ur?=
 =?utf-8?B?TGNuL0NEWjFMdXh0dWJ0L3VqTlZEY3pMakVNdHBWOG41MHpJMmUwbGV3MFI4?=
 =?utf-8?B?VDIwRWExb05PWnUybjBDZ1N0RUVwZmYwL213OUpMaE1IQjc2d3VZVjJyQXB3?=
 =?utf-8?B?RVpBZU0rUE5PUFd2WmJzdThyUk8xQVdBNy9LUVlGb3Q0a25YdHpvNlM5Mm5N?=
 =?utf-8?B?Q25KbFdWYSt4ZURyaFZIL2pjeVVrVW5HZ3N6amI2ODFLbllQUWE5L1lqNVor?=
 =?utf-8?Q?TvM+0a?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TUZoaXl3ZU9zS2RkMVhicTdXR3NTTi9qSENYVW9GV3NBTmlSRi9BUnVjTUkz?=
 =?utf-8?B?MS82ZjlaZkhYRUpwaHA1NVMwVHh0OUpzYXlUZExGVGFKOHQyemhtcEUxTTBs?=
 =?utf-8?B?NERtdURoNTJ3a0w5L2xyQlZjbm5FWExyMjFDTnhaaDZLNWJxWkUxUlR5emMv?=
 =?utf-8?B?VXRzSHJtbnpsVlo4L2ZqKzZ0THI0UW9KRTBUanZ0WGZLaU5qWS8zcTlSTTlW?=
 =?utf-8?B?UlRFdDF2UmkxR3ZGcVNWclJISXdTYmU3L0s4ZTU5RlhORGlHUGxhUkI4dnoy?=
 =?utf-8?B?N1laVmh5Zk9FdTVVMDZrVXdGOXlKdjdHL0JWYzRkZ1hUWWo0Y3dtLzdRMkl1?=
 =?utf-8?B?UWFsTWtVSXp3amFnbDBHbXM1WUtCM3NBUit4bDdYYkx0ckNudjlDYndHc1ov?=
 =?utf-8?B?S2xZTTlyR05aUC9LRXltSWJnVGNsRStNTTlxaTJxQXVoenhXQ3ZYNk5pRmVp?=
 =?utf-8?B?N1p1Z0liYkhSY2pFSWo2bWpENVNtbVZNVEdTK1o0YndvcnNSNUdvd09WZTY3?=
 =?utf-8?B?TGlBNGtqcXJrUEtnVm9ORnR4Q2Y5MHVYc1owVnMxRUVWMkpZbmliZG1ZQ0cv?=
 =?utf-8?B?UmhRd0lUTFJPSjA4SXhkVjFNbUtkN3FNVktLZ3piNTJ3M2s0SXdzbVJDd2Jj?=
 =?utf-8?B?aitKSFNHeVA4UW5uQlBXMUF0eFNHaWhKbmdIRUZiQXVjNDduenJockdsUzZ0?=
 =?utf-8?B?U25MQkR1VGxxYW91d2FEV2E4cjUwbzY5WTNCZGNVWEtmdVJBV3V0bWZxN1RJ?=
 =?utf-8?B?QXVvS1ZjYXpYZThlZWg1Vm1GTGJXb1IxN1FLZ1A2UElweHY4Lys3QzhIUHZ4?=
 =?utf-8?B?Q1JuQTMyTzBLZjNXYUd5UWJ6clBXSkYvMnQzVWJKc0NUTzVEWitBQWhQVnk1?=
 =?utf-8?B?UUJiajMzb0d2UHlZT2ZoK0ZUcmkrSHlXVXdhK1BadXhtd0t2R2RZejExMThG?=
 =?utf-8?B?S016Y054eGMvQ0ozb0kwSU9oelFlcFp4MU1sdWlaZTJpQ2JwT2pnc0JhVFdE?=
 =?utf-8?B?R3cvMzBROWhWeHZlNVk5ck9ITFQrcUhwTUxVVVAxSkpqZmlmQzdFWU1tNzIz?=
 =?utf-8?B?ZVJLNy9tdFg1N3V3eHdYUHNjSXJITVordkZHczBZU0xxOE1IMHZvRGFjbG5T?=
 =?utf-8?B?RWlQZ1dENFl6djQyUmdJQU1qUmdnbkdmTDRwNmxybFFJZnpGWnFwelJHRCtu?=
 =?utf-8?B?dCtpU1ZrZjF2NTNHblc0R0MweWU5L0Y3MXdCRzZNS096cFFudzQybVloYXkv?=
 =?utf-8?B?WjJZNG45dWo2VzNLZ1U0ZG1Dc2htOUlNZEtRblMvSlgwNnJWS21PRlFZZWpu?=
 =?utf-8?B?ZkdybW80YUo3dTUzWjFUZk1rWnlqVVlrdWdTamlka0NZWmU3ekc4SGVUa2hY?=
 =?utf-8?B?UmRhV2lEN0Z0dzNlWkYxbTkydDlmMlhMdDBKUUJCWUV2R1g1bXd6RWtqRlZW?=
 =?utf-8?B?WEw5MC80ZDdmdmRZZktUTmlUWDk2NXdYSFFURHpEaW92OUErQ25HOXIwQjFW?=
 =?utf-8?B?Qk1qbjkyRjBEeGl2SW1NQXZuZDNiMlMxc3A5OVc5dndsRmQ0aUNrRitGR1Jv?=
 =?utf-8?B?WGRjeEE3dVpBRWI5djRHN0J0YUNnRGQveU5FdTRzVWZadWlaYkNoM2NSUDJ5?=
 =?utf-8?B?TnRyU09FSzdUZmYyZDZtcS9aMHA2WG5vdkZISE12S3Y5a1R2ZkZBYjlYMlRt?=
 =?utf-8?B?UlF2Slh6cXQxNm1OMndQVWxROVE5dDhQS0lPZTNWZ2ZjKy9iM0gzRTROV2tT?=
 =?utf-8?B?TjdXNVFiRGlSeGJpWmQvYnJpdmFyanl0WVZ6TkNXZ2ZBK0p3VFQxNVAzUVVu?=
 =?utf-8?B?Q2VJd2QzN1dzQkhIVlhESUoyZ2p2ODZCeHVLVUdYK2N2cTdrNkhRU01DQ0ZJ?=
 =?utf-8?B?c0dhWGtBTUk0V2l0UkpZbjF2TkVLT1VxSDlJaHpxS3pBSlZVUHY0N093MW40?=
 =?utf-8?B?cm1uYTBPN2NoTFA2SkJITDVYYVVhbDF1VVFJZUpCTXdONndzRDFaTVFaVWE4?=
 =?utf-8?B?SjJjOFpPL05ndEhselFOYW1rWHE1N0M5SUFWdy9VdUpjNklPcnZ4YktVOHVX?=
 =?utf-8?B?ZGhZR2R2VXlSbGYrS2J4aEozNjhMRUlTaVRNWENlWmpDajRWZm9vdTZOcElp?=
 =?utf-8?B?ZTdJUmRYSFR4ZUdFREQwK2NtQkJWMTJlSGMyclZtbThud2JxMXdCZ2RHZkFF?=
 =?utf-8?B?TkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <87553263F84A9C4C8DCE92020E8192F2@namprd15.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b16f4c2a-48ab-4b43-25cf-08de157bb870
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 17:10:25.2258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YlfrJ8Qddyj9tpLTDpwHINJtLsEepr2sbqPg2ejF4N8MS+39VVS1PLZkBMVOdgIij1JnwGirkfAAvvcfFbyu2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4976
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI3MDE1OSBTYWx0ZWRfX77dUBHGN+NC4
 24TmjWDhVwQxwzh8OghULS11a3borTO2lyqGDPFOxhXG8/WRQZNGNfdB6gHUM4DpJcKucHi/s0w
 oDtPkp4DYBLB8pXNS5AH9tkCn6hm2ZtW51iYCLVyoA9SCXL6+FsC1Ed9ItG4DmPCfA02PM25h9B
 czO60CZ5ldtAYBgLUjLsvHzRwkgXsjB6VIYggk7uoNzAC68fCL71jP7UrEZXnuAyuDvOMHXPdJ1
 OGztjmlVDUlcGUxo0SEHvF0XSki3YXpK5luAi2BOJMIi1NyoABPq/QHh+7XV1Nt3gxwZ3oQgyL7
 WVKvgaSeslgtXv2Rm7EcmQDgDVf4bFXnQpmHE8DXu++JqnFkFU8rXtmxOmlrDF0MFLrFXzEeVXB
 xWgiSp+dmbCeDUJFrCzNMB9qOMX5aA==
X-Proofpoint-ORIG-GUID: SbZKCmYvqMj3erda9zTlKIML5wpyGTkK
X-Authority-Analysis: v=2.4 cv=aNv9aL9m c=1 sm=1 tr=0 ts=68ffa784 cx=c_pps
 a=zHP1L1ZDY46t+2XtVYLmoA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8
 a=m8_MaIrkB4xMcE-Zfc4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: SbZKCmYvqMj3erda9zTlKIML5wpyGTkK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-27_07,2025-10-22_01,2025-03-28_01

DQoNCj4gT24gT2N0IDI3LCAyMDI1LCBhdCAxOjQ44oCvQU0sIEppcmkgT2xzYSA8b2xzYWppcmlA
Z21haWwuY29tPiB3cm90ZToNCg0KW+KApl0NCj4gDQo+PiANCj4+IA0KPj4gZGlmZiAtLWdpdCBh
L2tlcm5lbC9icGYvdHJhbXBvbGluZS5jIGIva2VybmVsL2JwZi90cmFtcG9saW5lLmMNCj4+IGlu
ZGV4IDU5NDkwOTVlNTFjMy4uZjJjYjBiMDk3MDkzIDEwMDY0NA0KPj4gLS0tIGEva2VybmVsL2Jw
Zi90cmFtcG9saW5lLmMNCj4+ICsrKyBiL2tlcm5lbC9icGYvdHJhbXBvbGluZS5jDQo+PiBAQCAt
NDc5LDExICs0NzksNiBAQCBzdGF0aWMgaW50IGJwZl90cmFtcG9saW5lX3VwZGF0ZShzdHJ1Y3Qg
YnBmX3RyYW1wb2xpbmUgKnRyLCBib29sIGxvY2tfZGlyZWN0X211dA0KPj4gKiBCUEZfVFJBTVBf
Rl9TSEFSRV9JUE1PRElGWSBpcyBzZXQsIHdlIGNhbiBnZW5lcmF0ZSB0aGUNCj4+ICogdHJhbXBv
bGluZSBhZ2FpbiwgYW5kIHJldHJ5IHJlZ2lzdGVyLg0KPj4gKi8NCj4+IC0gLyogcmVzZXQgZm9w
cy0+ZnVuYyBhbmQgZm9wcy0+dHJhbXBvbGluZSBmb3IgcmUtcmVnaXN0ZXIgKi8NCj4+IC0gdHIt
PmZvcHMtPmZ1bmMgPSBOVUxMOw0KPj4gLSB0ci0+Zm9wcy0+dHJhbXBvbGluZSA9IDA7DQo+PiAt
DQo+PiAtIC8qIGZyZWUgaW0gbWVtb3J5IGFuZCByZWFsbG9jYXRlIGxhdGVyICovDQo+PiBicGZf
dHJhbXBfaW1hZ2VfZnJlZShpbSk7DQo+PiBnb3RvIGFnYWluOw0KPj4gfQ0KPj4gZGlmZiAtLWdp
dCBhL2tlcm5lbC90cmFjZS9mdHJhY2UuYyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gaW5k
ZXggNDJiZDJiYTY4YTgyLi43MjVjMjI0ZmI0ZTYgMTAwNjQ0DQo+PiAtLS0gYS9rZXJuZWwvdHJh
Y2UvZnRyYWNlLmMNCj4+ICsrKyBiL2tlcm5lbC90cmFjZS9mdHJhY2UuYw0KPj4gQEAgLTYwNDgs
NiArNjA0OCwxMiBAQCBpbnQgcmVnaXN0ZXJfZnRyYWNlX2RpcmVjdChzdHJ1Y3QgZnRyYWNlX29w
cyAqb3BzLCB1bnNpZ25lZCBsb25nIGFkZHIpDQo+PiBvcHMtPmRpcmVjdF9jYWxsID0gYWRkcjsN
Cj4+IA0KPj4gZXJyID0gcmVnaXN0ZXJfZnRyYWNlX2Z1bmN0aW9uX25vbG9jayhvcHMpOw0KPj4g
KyBpZiAoZXJyKSB7DQo+PiArIC8qIGNsZWFudXAgZm9yIHBvc3NpYmxlIGFub3RoZXIgcmVnaXN0
ZXIgY2FsbCAqLw0KPj4gKyBvcHMtPmZ1bmMgPSBOVUxMOw0KPj4gKyBvcHMtPnRyYW1wb2xpbmUg
PSAwOw0KPiANCj4gbml0LCB3ZSBjb3VsZCBjbGVhbnVwIGFsc28gZmxhZ3MgYW5kIGRpcmVjdF9j
YWxsIGp1c3QgdG8gYmUgY29tcGxldGUsDQo+IGJ1dCBhdCB0aGUgc2FtZSB0aW1lIGl0IGRvZXMg
bm90IHNlZW0gdG8gYWZmZWN0IGFueXRoaW5nDQoNCkkgYWN0dWFsbHkgdGhvdWdodCBhYm91dCB0
aGlzIGFuZCBkZWNpZGVkIHRvIHVzZSB0aGUgc2FtZSANCmxvZ2ljIGFzIHVucmVnaXN0ZXJfZnRy
YWNlX2RpcmVjdCgpLiANCg0KVGhhbmtzLA0KU29uZw0KDQoNCg==

