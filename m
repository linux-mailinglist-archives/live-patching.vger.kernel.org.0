Return-Path: <live-patching+bounces-23-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F3887E4FCE
	for <lists+live-patching@lfdr.de>; Wed,  8 Nov 2023 05:56:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF5CAB20D39
	for <lists+live-patching@lfdr.de>; Wed,  8 Nov 2023 04:56:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91D32137E;
	Wed,  8 Nov 2023 04:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X3G7tUu6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hnJbY7m6"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F896123
	for <live-patching@vger.kernel.org>; Wed,  8 Nov 2023 04:56:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4062193;
	Tue,  7 Nov 2023 20:56:49 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LK59G026459;
	Wed, 8 Nov 2023 04:55:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=B1RHbsTgbGkdMWW9XQzTP6Czmxdfpcq3zj0/EhwPhds=;
 b=X3G7tUu6i0bUpPlNGDcnSpmax55D3penTrDiRjo9tfA853JKhGRiHGXkcVepLtq8dED5
 P1+e3rKZvR8/FkbjEsNFi0S81AAnKKkHqYo1KxwWXMyoVMwvsLFGLpJYFaFW1JtWg0k4
 KNbZPj1pTC+lnP//1gGW8zZStDBKrf5rmg21S9A24Km/deV+xFHlntvttRI23mEtRGPV
 6Kb/Airb9NsJ+RqfMbSlP1XsvfgBO5MhXYKzIlRqHZyTvVsQHEF9SFDe3k9FJMw21TWc
 gaUzUuuCZDrCncL20V/Lz29U6kUtPFY8AiV+nHZGP2WeWcZJ6o27fRz+ZaVo9OZUWUdm 5Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w210kvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 04:55:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A840Uj0003805;
	Wed, 8 Nov 2023 04:55:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1w5s73-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 04:55:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fo2SZONBkkYtWCwBQWw5u/4S3JPpK2jGx+z+6SX5s6ZkssRBIjmx5/mzrAaLuhEnsM/LZjnyJZFQB/OieRgZ3k6jwcfSPXeMqB1/1upopASAEEod1PksA6ooU19ZUQQeWTm/xnS2/LyOQJAKyc9PFahhcjJTHppqBmyrbe3IC/VdbrCJ+nLTdZzKDykZC7o6ztpcp9WoRj6lXe6rqJhFmA5zsyki5eDJZCb9EthvRDNiiukEzQH2cZQFUi7qlLDt0LmIbAKoozUBZVEm++/XvhglkAwwX/Fl6oKjeplE+XE3cMfagS3hQykg3LLmLngp+DaptLXiJBOuX2xwJHmbZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B1RHbsTgbGkdMWW9XQzTP6Czmxdfpcq3zj0/EhwPhds=;
 b=CMjiQTnGueUt7HMRHfPTY8oHozv/GA0kMH3qGWX3Wb/54tyblwceQCR35YhvOGO6+Z2TPth/lm8zPuZ1uiY8bof9MRWLJUFyP8t0iuh40QatLn0Gnkn7vsQ7iPVmxUvIVhr/7fLA2mh71LEeqrNXY5OxK/WK+e172J+gRHJ72Lcw0cI2Xy1RROGb3sXrnSbvJLg4EjiC8Uz97/JNYMX/ZRLHdLGG4+U8qpYypWiv9ZAVap4/jxWJohR75Ap38Dh9FaqikJw8enVu13OtnMY4CwD9Gck5CqWyDBzepN2nzpVRrOlJaPxClJoOoZcDokxwgOjtFLg72smO+kqfnuymug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B1RHbsTgbGkdMWW9XQzTP6Czmxdfpcq3zj0/EhwPhds=;
 b=hnJbY7m6f8oRNQ5mfElYPiofmnIBWul6YZNzh8QGJlitQ8L9q7/hP0doNAhR10VJmIcXddg4DxgDtchc+I7+Rkooctpw0cZfdEOtLPnZl3OEAeXY00OgOKKBRs7UO+L1yn+BLp8OgJ9r1IsxjE5Mxte1uFaJBK54XmdllFzByBM=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CYXPR10MB7976.namprd10.prod.outlook.com (2603:10b6:930:df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Wed, 8 Nov
 2023 04:55:16 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76%4]) with mapi id 15.20.6977.018; Wed, 8 Nov 2023
 04:55:16 +0000
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
 <20231107215742.363031-8-ankur.a.arora@oracle.com>
 <20231107181609.7e9e9dcc@gandalf.local.home>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, peterz@infradead.org,
        torvalds@linux-foundation.org, paulmck@kernel.org, linux-mm@kvack.org,
        x86@kernel.org, akpm@linux-foundation.org, luto@kernel.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, juri.lelli@redhat.com, vincent.guittot@linaro.org,
        willy@infradead.org, mgorman@suse.de, jon.grimm@amd.com,
        bharata@amd.com, raghavendra.kt@amd.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, jgross@suse.com, andrew.cooper3@citrix.com,
        mingo@kernel.org, bristot@kernel.org, mathieu.desnoyers@efficios.com,
        geert@linux-m68k.org, glaubitz@physik.fu-berlin.de,
        anton.ivanov@cambridgegreys.com, mattst88@gmail.com,
        krypton@ulrich-teichert.org, David.Laight@ACULAB.COM, richard@nod.at,
        mjguzik@gmail.com, Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina
 <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        "Petr
 Mladek" <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 07/86] Revert "livepatch,sched: Add livepatch task
 switching to cond_resched()"
In-reply-to: <20231107181609.7e9e9dcc@gandalf.local.home>
Date: Tue, 07 Nov 2023 20:55:14 -0800
Message-ID: <874jhwvo7h.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CYXPR10MB7976:EE_
X-MS-Office365-Filtering-Correlation-Id: 3281ad45-4740-40a8-44e1-08dbe016e66f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SOvloYDL3UnnqcuZL9v64/+PJJwvLhn/y0FqXFGVeMBARlbg761KJhDTwv60LiEWsHWJBwIZ3ipuOkxdeXzR5YDQgd1clgLlN+st4OsLdpoIBg1hQkRYtMmICjjg6xIm/qj9LKYvPgsWQmMOPiZ+L7FLH9hBd0qSLJzr4ym3N1pldbuwh3qWccr/nrk43n5FNfdwnQY05SLp+7ftj5SH52hHFb3Cowcp5uR2Zsg1m79lxTPmn7UpB/4pR0bWW3oK7zKtUTeEqP4DGJwzbDdusjBLq5cf6J0SP0G1RaaGLzEVo9xLk2roMHRomKAwm/xh4xic3l69WkftxbR+YBR+7/XzbqXtRb0M0IbPoAPDXkkW4PvUz2d4mRQNUbPhXZv2kWv/4291fmMEUMKGCdqgL+UdJ417tDFg/DNIJ7hDPHXiJgG7IOR3CvfZaapBcyZyNs2KxWiWX0pV5VXgEkIWY7qYo5PkcSO1W2gWLe7WKkKBjoBUYspIdWMES8m9Kmv4AgyBr5AjLW72Edq4GgfqelrSOLwKmWFSgKh81BcWqOKhG7nND207uuf5xvdww1tT
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(26005)(2906002)(83380400001)(41300700001)(8936002)(8676002)(478600001)(4326008)(6486002)(86362001)(6506007)(66556008)(66946007)(316002)(66476007)(54906003)(6916009)(7416002)(7406005)(2616005)(5660300002)(30864003)(6512007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?1/pYi76CbS+hD0mNC7IVEf6e+JGUPoToro8+dufkTv6LDoJoyLsCkD8NTOYO?=
 =?us-ascii?Q?rgWcfAeG7nSJoP0rKp8cVf8QycXz5jAVSh8JNXfarIOuHbVajvy8vS5pYae2?=
 =?us-ascii?Q?3VFfmXjqYkwWj2tnA2nbMo8GL9VB+r+FcRHb9oh2OF/Y78G42/VSfsRnioDo?=
 =?us-ascii?Q?50X1UuLHmq/LURgiKRIfeb5X3HWpcaG273GZkltNC2OHwFJxRfo1lHJ8riJX?=
 =?us-ascii?Q?fKaxC/ENOAz6kdjVE+ZbTfFti61NN8pqiPk+oCbGQqA4h+VWqjJM3MJ6db67?=
 =?us-ascii?Q?zGSIMkEGzIJTa+bOwaCFy/Z1JakYzsllk37tgwKRwcfjuAJsbEkmmllA3aS6?=
 =?us-ascii?Q?2WqVNj50oZ0EN6QY3LfSG0yUerY4Y6PX+wTZ/P8O3nkzx1CMVPPo3hD0odnP?=
 =?us-ascii?Q?5lMR29AkwXSow7N7WQqPM+O43Q+nHs9yDba4+zMaLZvlIdz71thIiXNg0PxR?=
 =?us-ascii?Q?eoRhXmMei/PHkiwS52RcOSFD7K70CG3v9h4UpIt7bQh83ZbBaX2jFFWkOVL6?=
 =?us-ascii?Q?fzwVqf6tOs3g2VkENRt5kvTZwJnZgMPN6JWNT9QUHKurT4nlXDopJ/csdcCy?=
 =?us-ascii?Q?aJshYIQfQe+11z5z6bJ1vGrJ3BcoZn0dAycp6l0ly0z01NuqNoJOyKiN3DCi?=
 =?us-ascii?Q?DO4OSdN8+qo5J9p4XKm0RMe1imHrX5ZIYjgKxDCoXso8yJD0p3ftuPOk7Tch?=
 =?us-ascii?Q?8mf3OxGsbuHg7hOQPo5LOQYdcDHwYICOktxHvGF1ccsEg7b1czjJofZSCg0e?=
 =?us-ascii?Q?BCUSzlHWleaQpTN0UwQNnEHgcJa3nNSozJzdCY3x5CrDyjrlVSFfoYBIO9PG?=
 =?us-ascii?Q?JHktCH4h64ONNMTd4XuMgN70u8BNnVhJDnJjuQFFxTTsTeIaRd2HbL7dyP0l?=
 =?us-ascii?Q?jcBkYZBHu4zPnvrC9f5PXLdgIl8/AT3BAC4hPLJNN+vTvZaXXdZGHWKkyjCk?=
 =?us-ascii?Q?Toup/uozEMJ88It0BWJzEKxifmZqYrIHWBlavA4f2ezWvmCYk7kpqe5OwLoS?=
 =?us-ascii?Q?XwwyGFTB4uk2cYoY4QWY/UF3r2AFE9Mer6o7zUVLFFMLKdyEiE9c+xQ5A1Nv?=
 =?us-ascii?Q?0ChtCGLlIwvfS9gudrC5EbTRQP1IXRktl9Dw/r37EeY2GiA1kjCV+E7cAS2n?=
 =?us-ascii?Q?cP426k2jGvWHYTw0qaDZuLsdYsm6NXksIozzj4mQY+/igJoozpkshlRUrOT1?=
 =?us-ascii?Q?v5lCUrmFKKXRXzv2CXyqq6eSujnMrHo4pX22RtzfbvPsaIG/sBSkf7BMw+v8?=
 =?us-ascii?Q?yzhFUpaIwQGNdYh+ZFkOxPxWFoRJ7MXN+dGGqroxliAqprQbqxBiUYHET6rl?=
 =?us-ascii?Q?B87XWCFdL9citnvHCLFXxFEUnE1z1eL/nyjO04+oT176t7Dn/tNRIXNqvymt?=
 =?us-ascii?Q?3cJ3WP7NOb3/YtNxexHTHyh32P3yWCXLpz++0CA0wzb6FHr9eysPEs9iH4ui?=
 =?us-ascii?Q?fgMaPXbzOCt2v6W3EtHGvdn/4z8PO4YqxaYTcOU7KR2aQDY/E31dM0y1TnX5?=
 =?us-ascii?Q?YGN+YO1hTIL5CDY8xskXax4gL2o8WSTckswkr4RP3HGUpsodyWghBxfn3EEe?=
 =?us-ascii?Q?cAFt+FCt5iv6XPZeMexcImACG4mjPfRqiLJUq1A0VOkT38OQrnXd3XHXygnY?=
 =?us-ascii?Q?MA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?UzgJB0Fw9QBZ9Mpk5+QWK9vfn7v+sISrWvauBX2UWs/qBWsBr9v0iizEHcPK?=
 =?us-ascii?Q?3BhH7IWuvhumxAVnJLKgizS1qGnIszMxuJvm4kSxzHNMw/infQGfbDIOYCiB?=
 =?us-ascii?Q?iOgygqhqFfN3bPDr2vbpdCJaR5EsP3fu6txUXNKuxaf31pW13sjsnuNtBnO3?=
 =?us-ascii?Q?q8Mk0HBrjnWe0DeLHd3NeZWzh7rxUEzOhVm4R/zPsZKU9SYxjjyklGmL/YmT?=
 =?us-ascii?Q?Gt4b4Yd4d3APxaKT5bxPlaETPAeZmgH96EanNxa15OP8XPcVygeoFrE/2QJh?=
 =?us-ascii?Q?Lgse/IzR5Qwc+uPmodu5eBthhP8j9F1Mmva7/4AXLwJgQpFu6+hmEcbwgRdB?=
 =?us-ascii?Q?oDz01FGSdyw+RWTDloOWELQvroYqkRrfaOTpBZHCyGLxYhPLWJSSxl8328bI?=
 =?us-ascii?Q?jUzt9DtVZmfsX+BA/Ex0dH9OU1p0z2Bmm19cRKFAzpRni81zi1Z13rq2WpN9?=
 =?us-ascii?Q?EnCNv6m+0gB5+u5hMl7DW0Ww85tjRkMiBsab9Fzb0GqqLLN+NRxK7guwKFeM?=
 =?us-ascii?Q?IPco5lQpunAdfMDSsWP6icGzTUBsMbFOep8Pht+xui03mpWKyIhZE3b0BFLr?=
 =?us-ascii?Q?Hu3hpwNM2nT8nToMA7Yw1i6Nl8QvQT1PtBxqrGj1ej87vli8CJXrQCjF5xwl?=
 =?us-ascii?Q?vkXU+2+jDpHf0ePG3ss74RlW5PvKXyj0JGVm2TgZkNj5uvSNZuMXszXXo6aL?=
 =?us-ascii?Q?iAzVfqnwvrQOiJwj2CjYcAmeeKzO6JXDmE6/055prwsJVHMRiWGAvb0o2BQa?=
 =?us-ascii?Q?CcdXplQHTfNahAFKKryMz5x7exKSBBrB1qWABr1i3hvhagf9VFM+SQQOFi95?=
 =?us-ascii?Q?1kjp2RCH5hmdQrZFCurXpg/B5fvGy2M1wSJ2KJU17Tvf7Q6AfP0+0AyzzOfM?=
 =?us-ascii?Q?VrVm5VUA30jUjs1jv7s4+L5i+hHyLbaZFsVdjNBEHGX/Hr8q56+6YXdbCwpR?=
 =?us-ascii?Q?WaX8pFcCrOlMYk2LsEiYbyxahW2qay3RLD6uhLJvet/1/uNPbjEx1AuS6sUM?=
 =?us-ascii?Q?p0t2tIPlH7beWb8Q9nF8RJZ/h+DCADajpCf5yBlD/unqzBuk+POxOHaya2yx?=
 =?us-ascii?Q?EyBOjbRem8I5MxPfH6UmheqGR2HdR15XiQ712Uo9ARiAuENInNNGi91zthMq?=
 =?us-ascii?Q?7aVz5ph196zk79l6/nS3AZbIMJu3YzHi4zOVdG4osSlJ4FLyytLPz+7vZWep?=
 =?us-ascii?Q?5cATlJnWXkbJxlieIbsTqVY6Pv/FJqXKhqTtajZVZ/kjWlqe25ayEd6M6ABe?=
 =?us-ascii?Q?+Ri2e87pc8a6/gWWRXAq19qYQAM13BohO9gESbiIX7RrHyfeAcOtBCLAETM+?=
 =?us-ascii?Q?eczrlVvIRggDvmk/b+35cxtNXURmFxdd7OwbV5LpfSV1lj9hYh77B183WsRG?=
 =?us-ascii?Q?ZwHL6Qxf7BH+PmZWAbpszs8635XBGAv8Sbx0PNaFBiEJREdOkPiw2QUTYx0T?=
 =?us-ascii?Q?WFpO/ijr279u5GOZVBCueFsYWVyB9UqRXWAHbEU1D3sHMl5Xp/ujiOl0cHtp?=
 =?us-ascii?Q?zHC83PE/0gt7jFWdQVWeLHpn2e842Gz4NS5AzUznsy82noILIlxHbyc0QTLg?=
 =?us-ascii?Q?C5ckP9kQ3/cC8fP+j08=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3281ad45-4740-40a8-44e1-08dbe016e66f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 04:55:16.4606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uJEpdePM37WMjBSDnqWFn3g1hMeG3zgRX2t2dtb4eCdp5ZDuvef8UYbr8BjVHcpWhYWOKj7nc/lsYi8Rp20iE1lGUs5MgGOLIEJLQr4ynLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311080039
X-Proofpoint-GUID: ktjL2-RF9ulqELfiNRVeFB5PGwZULBko
X-Proofpoint-ORIG-GUID: ktjL2-RF9ulqELfiNRVeFB5PGwZULBko


Steven Rostedt <rostedt@goodmis.org> writes:

> On Tue,  7 Nov 2023 13:56:53 -0800
> Ankur Arora <ankur.a.arora@oracle.com> wrote:
>
>> This reverts commit e3ff7c609f39671d1aaff4fb4a8594e14f3e03f8.
>>
>> Note that removing this commit reintroduces "live patches failing to
>> complete within a reasonable amount of time due to CPU-bound kthreads."
>>
>> Unfortunately this fix depends quite critically on PREEMPT_DYNAMIC and
>> existence of cond_resched() so this will need an alternate fix.
>>
>
> Then it would probably be a good idea to Cc the live patching maintainers!

Indeed. Could have sworn that I had. But clearly not.

Apologies and thanks for adding them.

>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  include/linux/livepatch.h       |   1 -
>>  include/linux/livepatch_sched.h |  29 ---------
>>  include/linux/sched.h           |  20 ++----
>>  kernel/livepatch/core.c         |   1 -
>>  kernel/livepatch/transition.c   | 107 +++++---------------------------
>>  kernel/sched/core.c             |  64 +++----------------
>>  6 files changed, 28 insertions(+), 194 deletions(-)
>>  delete mode 100644 include/linux/livepatch_sched.h
>>
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 9b9b38e89563..293e29960c6e 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -13,7 +13,6 @@
>>  #include <linux/ftrace.h>
>>  #include <linux/completion.h>
>>  #include <linux/list.h>
>> -#include <linux/livepatch_sched.h>
>>
>>  #if IS_ENABLED(CONFIG_LIVEPATCH)
>>
>> diff --git a/include/linux/livepatch_sched.h b/include/linux/livepatch_sched.h
>> deleted file mode 100644
>> index 013794fb5da0..000000000000
>> --- a/include/linux/livepatch_sched.h
>> +++ /dev/null
>> @@ -1,29 +0,0 @@
>> -/* SPDX-License-Identifier: GPL-2.0-or-later */
>> -#ifndef _LINUX_LIVEPATCH_SCHED_H_
>> -#define _LINUX_LIVEPATCH_SCHED_H_
>> -
>> -#include <linux/jump_label.h>
>> -#include <linux/static_call_types.h>
>> -
>> -#ifdef CONFIG_LIVEPATCH
>> -
>> -void __klp_sched_try_switch(void);
>> -
>> -#if !defined(CONFIG_PREEMPT_DYNAMIC) || !defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
>> -
>> -DECLARE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
>> -
>> -static __always_inline void klp_sched_try_switch(void)
>> -{
>> -	if (static_branch_unlikely(&klp_sched_try_switch_key))
>> -		__klp_sched_try_switch();
>> -}
>> -
>> -#endif /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>> -
>> -#else /* !CONFIG_LIVEPATCH */
>> -static inline void klp_sched_try_switch(void) {}
>> -static inline void __klp_sched_try_switch(void) {}
>> -#endif /* CONFIG_LIVEPATCH */
>> -
>> -#endif /* _LINUX_LIVEPATCH_SCHED_H_ */
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 5bdf80136e42..c5b0ef1ecfe4 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -36,7 +36,6 @@
>>  #include <linux/seqlock.h>
>>  #include <linux/kcsan.h>
>>  #include <linux/rv.h>
>> -#include <linux/livepatch_sched.h>
>>  #include <asm/kmap_size.h>
>>
>>  /* task_struct member predeclarations (sorted alphabetically): */
>> @@ -2087,9 +2086,6 @@ extern int __cond_resched(void);
>>
>>  #if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
>>
>> -void sched_dynamic_klp_enable(void);
>> -void sched_dynamic_klp_disable(void);
>> -
>>  DECLARE_STATIC_CALL(cond_resched, __cond_resched);
>>
>>  static __always_inline int _cond_resched(void)
>> @@ -2098,7 +2094,6 @@ static __always_inline int _cond_resched(void)
>>  }
>>
>>  #elif defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_KEY)
>> -
>>  extern int dynamic_cond_resched(void);
>>
>>  static __always_inline int _cond_resched(void)
>> @@ -2106,25 +2101,20 @@ static __always_inline int _cond_resched(void)
>>  	return dynamic_cond_resched();
>>  }
>>
>> -#else /* !CONFIG_PREEMPTION */
>> +#else
>>
>>  static inline int _cond_resched(void)
>>  {
>> -	klp_sched_try_switch();
>>  	return __cond_resched();
>>  }
>>
>> -#endif /* PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>> +#endif /* CONFIG_PREEMPT_DYNAMIC */
>>
>> -#else /* CONFIG_PREEMPTION && !CONFIG_PREEMPT_DYNAMIC */
>> +#else
>>
>> -static inline int _cond_resched(void)
>> -{
>> -	klp_sched_try_switch();
>> -	return 0;
>> -}
>> +static inline int _cond_resched(void) { return 0; }
>>
>> -#endif /* !CONFIG_PREEMPTION || CONFIG_PREEMPT_DYNAMIC */
>> +#endif /* !defined(CONFIG_PREEMPTION) || defined(CONFIG_PREEMPT_DYNAMIC) */
>>
>>  #define cond_resched() ({			\
>>  	__might_resched(__FILE__, __LINE__, 0);	\
>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>> index 61328328c474..fc851455740c 100644
>> --- a/kernel/livepatch/core.c
>> +++ b/kernel/livepatch/core.c
>> @@ -33,7 +33,6 @@
>>   *
>>   * - klp_ftrace_handler()
>>   * - klp_update_patch_state()
>> - * - __klp_sched_try_switch()
>>   */
>>  DEFINE_MUTEX(klp_mutex);
>>
>> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
>> index e54c3d60a904..70bc38f27af7 100644
>> --- a/kernel/livepatch/transition.c
>> +++ b/kernel/livepatch/transition.c
>> @@ -9,7 +9,6 @@
>>
>>  #include <linux/cpu.h>
>>  #include <linux/stacktrace.h>
>> -#include <linux/static_call.h>
>>  #include "core.h"
>>  #include "patch.h"
>>  #include "transition.h"
>> @@ -27,25 +26,6 @@ static int klp_target_state = KLP_UNDEFINED;
>>
>>  static unsigned int klp_signals_cnt;
>>
>> -/*
>> - * When a livepatch is in progress, enable klp stack checking in
>> - * cond_resched().  This helps CPU-bound kthreads get patched.
>> - */
>> -#if defined(CONFIG_PREEMPT_DYNAMIC) && defined(CONFIG_HAVE_PREEMPT_DYNAMIC_CALL)
>> -
>> -#define klp_cond_resched_enable() sched_dynamic_klp_enable()
>> -#define klp_cond_resched_disable() sched_dynamic_klp_disable()
>> -
>> -#else /* !CONFIG_PREEMPT_DYNAMIC || !CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>> -
>> -DEFINE_STATIC_KEY_FALSE(klp_sched_try_switch_key);
>> -EXPORT_SYMBOL(klp_sched_try_switch_key);
>> -
>> -#define klp_cond_resched_enable() static_branch_enable(&klp_sched_try_switch_key)
>> -#define klp_cond_resched_disable() static_branch_disable(&klp_sched_try_switch_key)
>> -
>> -#endif /* CONFIG_PREEMPT_DYNAMIC && CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>> -
>>  /*
>>   * This work can be performed periodically to finish patching or unpatching any
>>   * "straggler" tasks which failed to transition in the first attempt.
>> @@ -194,8 +174,8 @@ void klp_update_patch_state(struct task_struct *task)
>>  	 * barrier (smp_rmb) for two cases:
>>  	 *
>>  	 * 1) Enforce the order of the TIF_PATCH_PENDING read and the
>> -	 *    klp_target_state read.  The corresponding write barriers are in
>> -	 *    klp_init_transition() and klp_reverse_transition().
>> +	 *    klp_target_state read.  The corresponding write barrier is in
>> +	 *    klp_init_transition().
>>  	 *
>>  	 * 2) Enforce the order of the TIF_PATCH_PENDING read and a future read
>>  	 *    of func->transition, if klp_ftrace_handler() is called later on
>> @@ -363,44 +343,6 @@ static bool klp_try_switch_task(struct task_struct *task)
>>  	return !ret;
>>  }
>>
>> -void __klp_sched_try_switch(void)
>> -{
>> -	if (likely(!klp_patch_pending(current)))
>> -		return;
>> -
>> -	/*
>> -	 * This function is called from cond_resched() which is called in many
>> -	 * places throughout the kernel.  Using the klp_mutex here might
>> -	 * deadlock.
>> -	 *
>> -	 * Instead, disable preemption to prevent racing with other callers of
>> -	 * klp_try_switch_task().  Thanks to task_call_func() they won't be
>> -	 * able to switch this task while it's running.
>> -	 */
>> -	preempt_disable();
>> -
>> -	/*
>> -	 * Make sure current didn't get patched between the above check and
>> -	 * preempt_disable().
>> -	 */
>> -	if (unlikely(!klp_patch_pending(current)))
>> -		goto out;
>> -
>> -	/*
>> -	 * Enforce the order of the TIF_PATCH_PENDING read above and the
>> -	 * klp_target_state read in klp_try_switch_task().  The corresponding
>> -	 * write barriers are in klp_init_transition() and
>> -	 * klp_reverse_transition().
>> -	 */
>> -	smp_rmb();
>> -
>> -	klp_try_switch_task(current);
>> -
>> -out:
>> -	preempt_enable();
>> -}
>> -EXPORT_SYMBOL(__klp_sched_try_switch);
>> -
>>  /*
>>   * Sends a fake signal to all non-kthread tasks with TIF_PATCH_PENDING set.
>>   * Kthreads with TIF_PATCH_PENDING set are woken up.
>> @@ -507,8 +449,7 @@ void klp_try_complete_transition(void)
>>  		return;
>>  	}
>>
>> -	/* Done!  Now cleanup the data structures. */
>> -	klp_cond_resched_disable();
>> +	/* we're done, now cleanup the data structures */
>>  	patch = klp_transition_patch;
>>  	klp_complete_transition();
>>
>> @@ -560,8 +501,6 @@ void klp_start_transition(void)
>>  			set_tsk_thread_flag(task, TIF_PATCH_PENDING);
>>  	}
>>
>> -	klp_cond_resched_enable();
>> -
>>  	klp_signals_cnt = 0;
>>  }
>>
>> @@ -617,9 +556,8 @@ void klp_init_transition(struct klp_patch *patch, int state)
>>  	 * see a func in transition with a task->patch_state of KLP_UNDEFINED.
>>  	 *
>>  	 * Also enforce the order of the klp_target_state write and future
>> -	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() and
>> -	 * __klp_sched_try_switch() don't set a task->patch_state to
>> -	 * KLP_UNDEFINED.
>> +	 * TIF_PATCH_PENDING writes to ensure klp_update_patch_state() doesn't
>> +	 * set a task->patch_state to KLP_UNDEFINED.
>>  	 */
>>  	smp_wmb();
>>
>> @@ -655,10 +593,14 @@ void klp_reverse_transition(void)
>>  		 klp_target_state == KLP_PATCHED ? "patching to unpatching" :
>>  						   "unpatching to patching");
>>
>> +	klp_transition_patch->enabled = !klp_transition_patch->enabled;
>> +
>> +	klp_target_state = !klp_target_state;
>> +
>>  	/*
>>  	 * Clear all TIF_PATCH_PENDING flags to prevent races caused by
>> -	 * klp_update_patch_state() or __klp_sched_try_switch() running in
>> -	 * parallel with the reverse transition.
>> +	 * klp_update_patch_state() running in parallel with
>> +	 * klp_start_transition().
>>  	 */
>>  	read_lock(&tasklist_lock);
>>  	for_each_process_thread(g, task)
>> @@ -668,28 +610,9 @@ void klp_reverse_transition(void)
>>  	for_each_possible_cpu(cpu)
>>  		clear_tsk_thread_flag(idle_task(cpu), TIF_PATCH_PENDING);
>>
>> -	/*
>> -	 * Make sure all existing invocations of klp_update_patch_state() and
>> -	 * __klp_sched_try_switch() see the cleared TIF_PATCH_PENDING before
>> -	 * starting the reverse transition.
>> -	 */
>> +	/* Let any remaining calls to klp_update_patch_state() complete */
>>  	klp_synchronize_transition();
>>
>> -	/*
>> -	 * All patching has stopped, now re-initialize the global variables to
>> -	 * prepare for the reverse transition.
>> -	 */
>> -	klp_transition_patch->enabled = !klp_transition_patch->enabled;
>> -	klp_target_state = !klp_target_state;
>> -
>> -	/*
>> -	 * Enforce the order of the klp_target_state write and the
>> -	 * TIF_PATCH_PENDING writes in klp_start_transition() to ensure
>> -	 * klp_update_patch_state() and __klp_sched_try_switch() don't set
>> -	 * task->patch_state to the wrong value.
>> -	 */
>> -	smp_wmb();
>> -
>>  	klp_start_transition();
>>  }
>>
>> @@ -703,9 +626,9 @@ void klp_copy_process(struct task_struct *child)
>>  	 * the task flag up to date with the parent here.
>>  	 *
>>  	 * The operation is serialized against all klp_*_transition()
>> -	 * operations by the tasklist_lock. The only exceptions are
>> -	 * klp_update_patch_state(current) and __klp_sched_try_switch(), but we
>> -	 * cannot race with them because we are current.
>> +	 * operations by the tasklist_lock. The only exception is
>> +	 * klp_update_patch_state(current), but we cannot race with
>> +	 * that because we are current.
>>  	 */
>>  	if (test_tsk_thread_flag(current, TIF_PATCH_PENDING))
>>  		set_tsk_thread_flag(child, TIF_PATCH_PENDING);
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 0e8764d63041..b43fda3c5733 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -8597,7 +8597,6 @@ EXPORT_STATIC_CALL_TRAMP(might_resched);
>>  static DEFINE_STATIC_KEY_FALSE(sk_dynamic_cond_resched);
>>  int __sched dynamic_cond_resched(void)
>>  {
>> -	klp_sched_try_switch();
>>  	if (!static_branch_unlikely(&sk_dynamic_cond_resched))
>>  		return 0;
>>  	return __cond_resched();
>> @@ -8746,17 +8745,13 @@ int sched_dynamic_mode(const char *str)
>>  #error "Unsupported PREEMPT_DYNAMIC mechanism"
>>  #endif
>>
>> -DEFINE_MUTEX(sched_dynamic_mutex);
>> -static bool klp_override;
>> -
>> -static void __sched_dynamic_update(int mode)
>> +void sched_dynamic_update(int mode)
>>  {
>>  	/*
>>  	 * Avoid {NONE,VOLUNTARY} -> FULL transitions from ever ending up in
>>  	 * the ZERO state, which is invalid.
>>  	 */
>> -	if (!klp_override)
>> -		preempt_dynamic_enable(cond_resched);
>> +	preempt_dynamic_enable(cond_resched);
>>  	preempt_dynamic_enable(might_resched);
>>  	preempt_dynamic_enable(preempt_schedule);
>>  	preempt_dynamic_enable(preempt_schedule_notrace);
>> @@ -8764,79 +8759,36 @@ static void __sched_dynamic_update(int mode)
>>
>>  	switch (mode) {
>>  	case preempt_dynamic_none:
>> -		if (!klp_override)
>> -			preempt_dynamic_enable(cond_resched);
>> +		preempt_dynamic_enable(cond_resched);
>>  		preempt_dynamic_disable(might_resched);
>>  		preempt_dynamic_disable(preempt_schedule);
>>  		preempt_dynamic_disable(preempt_schedule_notrace);
>>  		preempt_dynamic_disable(irqentry_exit_cond_resched);
>> -		if (mode != preempt_dynamic_mode)
>> -			pr_info("Dynamic Preempt: none\n");
>> +		pr_info("Dynamic Preempt: none\n");
>>  		break;
>>
>>  	case preempt_dynamic_voluntary:
>> -		if (!klp_override)
>> -			preempt_dynamic_enable(cond_resched);
>> +		preempt_dynamic_enable(cond_resched);
>>  		preempt_dynamic_enable(might_resched);
>>  		preempt_dynamic_disable(preempt_schedule);
>>  		preempt_dynamic_disable(preempt_schedule_notrace);
>>  		preempt_dynamic_disable(irqentry_exit_cond_resched);
>> -		if (mode != preempt_dynamic_mode)
>> -			pr_info("Dynamic Preempt: voluntary\n");
>> +		pr_info("Dynamic Preempt: voluntary\n");
>>  		break;
>>
>>  	case preempt_dynamic_full:
>> -		if (!klp_override)
>> -			preempt_dynamic_disable(cond_resched);
>> +		preempt_dynamic_disable(cond_resched);
>>  		preempt_dynamic_disable(might_resched);
>>  		preempt_dynamic_enable(preempt_schedule);
>>  		preempt_dynamic_enable(preempt_schedule_notrace);
>>  		preempt_dynamic_enable(irqentry_exit_cond_resched);
>> -		if (mode != preempt_dynamic_mode)
>> -			pr_info("Dynamic Preempt: full\n");
>> +		pr_info("Dynamic Preempt: full\n");
>>  		break;
>>  	}
>>
>>  	preempt_dynamic_mode = mode;
>>  }
>>
>> -void sched_dynamic_update(int mode)
>> -{
>> -	mutex_lock(&sched_dynamic_mutex);
>> -	__sched_dynamic_update(mode);
>> -	mutex_unlock(&sched_dynamic_mutex);
>> -}
>> -
>> -#ifdef CONFIG_HAVE_PREEMPT_DYNAMIC_CALL
>> -
>> -static int klp_cond_resched(void)
>> -{
>> -	__klp_sched_try_switch();
>> -	return __cond_resched();
>> -}
>> -
>> -void sched_dynamic_klp_enable(void)
>> -{
>> -	mutex_lock(&sched_dynamic_mutex);
>> -
>> -	klp_override = true;
>> -	static_call_update(cond_resched, klp_cond_resched);
>> -
>> -	mutex_unlock(&sched_dynamic_mutex);
>> -}
>> -
>> -void sched_dynamic_klp_disable(void)
>> -{
>> -	mutex_lock(&sched_dynamic_mutex);
>> -
>> -	klp_override = false;
>> -	__sched_dynamic_update(preempt_dynamic_mode);
>> -
>> -	mutex_unlock(&sched_dynamic_mutex);
>> -}
>> -
>> -#endif /* CONFIG_HAVE_PREEMPT_DYNAMIC_CALL */
>> -
>>  static int __init setup_preempt_mode(char *str)
>>  {
>>  	int mode = sched_dynamic_mode(str);


--
ankur

