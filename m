Return-Path: <live-patching+bounces-27-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BB87E748F
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 23:52:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AE68B20E92
	for <lists+live-patching@lfdr.de>; Thu,  9 Nov 2023 22:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C5B920315;
	Thu,  9 Nov 2023 22:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="thIzxnvw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CzcAv+uP"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695C730CE4
	for <live-patching@vger.kernel.org>; Thu,  9 Nov 2023 22:52:13 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3034220;
	Thu,  9 Nov 2023 14:52:12 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MZH7W016127;
	Thu, 9 Nov 2023 22:50:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : date : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=sEGTAnMhOnNsUybv+yNcpRZioYp92d0oVYRMp1O/a+Q=;
 b=thIzxnvwwDu237a1hJGuwF+VgIXkx4ITK+y0zU2Z0aJHlLW8OM3x3ROdOF6CI/tbqmYm
 ZT6oNclBrK0sbxPbZUdH2M0YOgrrb/UAn+wMOMkq4TLpa7kWNCJrXncWvxq2jWVDA1fM
 8HJBFltvpac353R78ZR2vytzkcUk4gTDIYACkgUBL2p055D3Aw0/kGkT3g0DGEGH3ZAO
 5udyfBJI0jL9XQowLRGlo1Zxewz6Pmjgl/848bfSY4ZWDIKdadwqVAkcQp87W+B4SwaL
 wYmqyVlrbxF8/oScIlgH6V8nyPT7lWr0ofRR11HFNxIxT18OfQ724bJYHWJalENIqSVH Hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w26w35v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Nov 2023 22:50:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9LjGxV017682;
	Thu, 9 Nov 2023 22:50:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u8c012r20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Nov 2023 22:50:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSn/jEs7sIDZ6jSiHDacy80UY3DjgqipDBONxbUIX2XT8XkKMtOF2bcfPJn+RwoOpopffAQcetqu+ceWnRnH2KhUMkaR05DYGKRuWvbz9sl9KwLtd3AtTMN12m1uH7MimWqWjM8EQFzzjYekaE0ILWyVWnWe9R8+nTAwEySbTklOXtWfok5Dkq3gxJpX7LHkf140wxu7bj4x5tR0fSs8quAxJBJ1vlDCLPYAbDKlG20W5PZJa7sm55fU86HBIlkESGiEwBwwvw+AQUcqpdMpy96J+1uGksYY+nFDwNbyGTrImnG/gTRUfyNfNmlrbvAAsxpSroxv4xJhj69xm+mogA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sEGTAnMhOnNsUybv+yNcpRZioYp92d0oVYRMp1O/a+Q=;
 b=ML4vg5YwYt5fF+CsErB66XSbixAjbxVmGshKPt+VKnYUGBTzKmH39TJa/mS0jkHI0xqvidFK19L10m+JmOIJE7blp6c92KTBI9L/wPIk5pBXT3tsptzpLm3I5kuy5BYSQpL+UIZvdYcXVwb/XJFTgAMe2yegvtlOphIjQ857MrMzgS7Oa5Om9F9j505N2z+MNoyXfeVsXvwey71KH25H/WXSKRySpfr6ME+7fE0Xfxtym9d7h0MtJrrvcR5mknRXUWFzxhWHGzvXtyQVGmRIXZtnqsijW5Rt2BYuO4f7+gm9L3PgBwnzlyq1QNrrCW4lD/MK+VlSTH5mDr3j3OVv0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEGTAnMhOnNsUybv+yNcpRZioYp92d0oVYRMp1O/a+Q=;
 b=CzcAv+uPU6Ea32y1gT/3kjx2BvRjCcDb5fI5NFN6sbW4Uq04VN7Ks02K+obEhrTqB+3G5+/c86V02xbpyoEY6ZQcT8BDzp0WPmKq/5DC11VN1CH7dttgavOdO2IU/QTV8VKxYNUb0DDSR7Qr73O/Yd2AhLu/tVGl64B7E3rRTfY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB7830.namprd10.prod.outlook.com (2603:10b6:806:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Thu, 9 Nov
 2023 22:50:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76%4]) with mapi id 15.20.6977.018; Thu, 9 Nov 2023
 22:50:50 +0000
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
 <20231107215742.363031-8-ankur.a.arora@oracle.com>
 <20231107181609.7e9e9dcc@gandalf.local.home>
 <20231109172637.ayue3jexgdxd53tu@treble>
 <20231109123147.2bb11809@gandalf.local.home>
 <20231109175118.olggitpaltz47n3b@treble>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Ankur Arora
 <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
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
        mjguzik@gmail.com, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes
 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence
 <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 07/86] Revert "livepatch,sched: Add livepatch task
 switching to cond_resched()"
In-reply-to: <20231109175118.olggitpaltz47n3b@treble>
Date: Thu, 09 Nov 2023 14:50:48 -0800
Message-ID: <87o7g2bkxj.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:303:b9::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: f79b062a-e375-4c31-cfd7-08dbe1765209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Nuymlk8vuhjlSw1Pj4XHxXBsl4RMDeBzadGkTlTTIVYS6LV1Xb6IB8bXQLIPeMrL6rxNmJtlQ/qe3U2rjQhuNeoy03B9e9zuumZza4BWlpiz5uGz8A7JYkRCyXrPFc5CqGlQ5CEAnDwvtiZBVVRt568c8PErPZhVSi+XPyAyJM1hX3YxhnmjyciEyk2dCYcjha+aY++jJd4iCHh/KauP0yolaPvi1W6r88O/PqIoaiLMbZ0f6OURGloeJ3yhhLjomNruITitylAwTzW4HZN3RdJR4LeXGsXqeZdO6F6q98F4BJv1ABbHtPC55hBgRuaHJNs52zxObzTCKiFsbJw5jNKKltofW2e/ZUlclftfshlFPZcI3vQalIQjS6hW6Q9WcUZhM19GLmH+ohI8rQOP+iyJjiYdsSSJQOQj98zB1zTlCRUx3LLBM3DUmvJRPOi9r+GX8jPmLQ4bfXu08GB/dXblPGxc4+etjprsoI1q7xuAN4zthWw7GyRtSdykMxJxsUp/BumxH7kvs6xurkPlBfBVpQ107xwYdebMa05IJ7hoHOiU2SWdN5vXLCOvev/n
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(376002)(396003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(26005)(2616005)(6512007)(83380400001)(478600001)(6506007)(6486002)(2906002)(38100700002)(66946007)(316002)(66556008)(66476007)(6916009)(54906003)(7416002)(5660300002)(8936002)(41300700001)(8676002)(86362001)(36756003)(4326008)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?bsY/V4kAziRpiM4c+yaHtZ/0IVdC0Jqcz//z9LtgMRxLhuzqMOpxmDv5ZjWd?=
 =?us-ascii?Q?jRZn+KBK0DKHNsWeapluBTiFWAceHIjQ77HxFIsCGSb8bEELl7ThI+90XVg6?=
 =?us-ascii?Q?dth9Kdg82rinIaZOy6rYngXhoxn4QcDY1IuuliQxr5E9Wtoyr9KMT+0uCPe5?=
 =?us-ascii?Q?mp87EBWaDfuzKg/xduOi6XF/2QVUvpEEtrxt59J7Ycpx6LUqT8hp1btPaT8e?=
 =?us-ascii?Q?EY0XMrFmoxn8CjquLiVTTRUcx/iuiKpEaCh1UYl4I/lNKIOlq2gYkEXHsys5?=
 =?us-ascii?Q?+UQJ8tnBDYdSnJ7GXVHZzPpgFFefd3d7kzEPdMSzBhUjv6IFwup1SiRx9WU5?=
 =?us-ascii?Q?Ttz6x2BH1Uv4m463UcOqjAcwef+z140iGXfNYIixhD8sx8GfpSa0WNUm2Dfn?=
 =?us-ascii?Q?Cg9QW4NG8afd6vOmMyLXOv9e2hJeKxSgVnpq+s4mQFRyvMvatADhDf13ydts?=
 =?us-ascii?Q?R3v8qTJCmVIn6GF4TGEFZYR/GW3HhT6WTWYJa/zX6WIeh7rbQYBs1fK3b6la?=
 =?us-ascii?Q?WkuaPsdxRwP2Js/2S0ZbGpHHo7NEUOZYGcZEz/vnOR8Mm8SclW3MniWAt1Cd?=
 =?us-ascii?Q?tCQreeKTExOOXproASDKFc1YDcGE0S/l2t1jus9v3INnhSgPGyjMqJf0FEW8?=
 =?us-ascii?Q?0cP+9iqOGjzG+7iwVdCxHaZi9eBqRkJB1/dWbgYDORwS7bqKewqaaldfPy9P?=
 =?us-ascii?Q?fp/yhB+xxvN7Gu+muM2Ekmmxcqt67jcvNxyMqarOSMXU9xjLavcL9hOku0rj?=
 =?us-ascii?Q?xQ+KzPUU94VAR3/iDvQ8Xmnh21oYP0eBd7ecN0AZ4KQXIngakNVPL8lEPf4x?=
 =?us-ascii?Q?neQTwdIT9ptij936qe1vO3XVZHOf+vyx5m1K3a8FIKMDCshRWOUR9rPQP6SO?=
 =?us-ascii?Q?7syl+GX+a2mWePhuvNTNxW1dp5/qSJgHJ8eqZ45HwjEh3TTMAH/5GpgM7+vn?=
 =?us-ascii?Q?gs2Kn8su8eBKH9Z/acdmhOZ6QP9Yhj1lSuI6CqYKk7EJot7Nam7LxW/fCQ4u?=
 =?us-ascii?Q?2KsW4OImSmc4tmUNDFGYFO6ojDYD8CwfdpiYLvdELrIEz7SrJxc35ON1ubXl?=
 =?us-ascii?Q?wc6W3BXwOB/kzVmMChcU8CLRbv9fXofhy1qqPctOuN99hwkZYUeRIILTbGmo?=
 =?us-ascii?Q?et63FGXH099VcKfwgJoZ7hUjLFefXKauqXgUFYWH4yguuwMKAGKSfbwBWjo8?=
 =?us-ascii?Q?RBG94J3J9UpkZStkrDTizRn2hW/v7rn3l8jQsXm9z5r/exxtlQ7glNnlXS1N?=
 =?us-ascii?Q?+7af9+rq5USl5IXvHclq2JWlOjvBO3lVXTx0b94dRzc8upuITEbOC+TDy/VV?=
 =?us-ascii?Q?HVqVnv0HMVeHfdIwhDCtmRnXAmAqTuk97eWcU6pF0Di0OXEl5V9aGzCWWvy1?=
 =?us-ascii?Q?s/i8kZw4D4Q9aNve/bBK63ICEZlM2+5e39d+RfW4Aoq4CmGjlQhJEC1P+d1X?=
 =?us-ascii?Q?g9Rw+j4+T4NfC31+pZoOj3K5XyOjiDbOu0ZrEkzvwWlCCMn2U857v89jEW16?=
 =?us-ascii?Q?VY6xzjBG+444LmsF1LhuRmBM4AnN26zSbUqsaTcjMdlgd4GnxG/xprYxCIg7?=
 =?us-ascii?Q?tNAbniILc+zKdfiuOC9tT2Cu5uXj5cgHMEgTfrmhKzCHtPO1cu0Nb413xiK3?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?5+glfkug0lOMiCLtiMIpf/PbNRZSgAJaO2OnL0lEhGnPemUzjLbkNjjYrhKm?=
 =?us-ascii?Q?q5dqioc9TzCR9fpw9UlbaxFtX/vuDAerdaiJlZQ7ALiGtEBlsr0qn72kNQ7G?=
 =?us-ascii?Q?dhLxmwMbrQI2kXaKAU+ANbTlldNMXTGGMrr3lN8I0odk2txynxLUyrTzEqTz?=
 =?us-ascii?Q?gu0lKGui7gYhMf9kDQ2Ms/oITcobZix+dQj2Bgh1LWFEuimv8VIkZl8UiiE4?=
 =?us-ascii?Q?WcxUtvw9hC7R1+5VeEwDKm1MLpI04/Rgh5IKq64DZDPKDMPrtX+jvES/l5fc?=
 =?us-ascii?Q?Kque7+ZjDAGhkpudbiXeXBrtjlvG4FCgcLgBOveqooLZBmlzXY2Ckkz4dKts?=
 =?us-ascii?Q?GFJxC7Rvy0ma/cvf6v1QCbdsycn3XnO6ImhNCJAcBaTuzOQzeGbcJMYoYnix?=
 =?us-ascii?Q?UyA7BIBPmIX8rmbvnqi1uxdZGJHWaTKocyXFJjMJRUfwTbUWb+cHGkWGBcSx?=
 =?us-ascii?Q?FP2uVZ+LrRT3ZW2kxt76whDMdblI4IPVh+HDhl4kGZUB2GeqcMxzJZ0lFVWx?=
 =?us-ascii?Q?G9tVVHY2pQGV+9V9x20Mvq63TH5U4rcLazvfdEVo546vrW1CkKJVsfaY96u+?=
 =?us-ascii?Q?PJan232eG7Z2azHqjJulF2Mt0HlLfGXqCUGFBr1Oz6s7m9Y0KccezTk6lYno?=
 =?us-ascii?Q?gQmohf2D2mumpPmruPSQ7QbhR7BZJUwXGjILHyjxQT2n05pAbfjlp5BXWaPP?=
 =?us-ascii?Q?YyqwO11iEQRNnlYdo4pNmtX+OVxwcNEHMr1jtXVXbrmBTo1nOt3Y96scN3J1?=
 =?us-ascii?Q?WogqRLSnarRxp2GKsKyhPwZzEq/le5uZ/a7HLAJIx+BD4EeTz+3Y/o6rEjpI?=
 =?us-ascii?Q?pxrONKVJ3L5/hSJ2nTQ78Is/3SMC/q4k+X23W2SyPLs/a99cznBp5XEzbji2?=
 =?us-ascii?Q?5yfW3GCBQWtIVwubADK/jv+iSqkEqFoBlHsTa8vhJcIoOsx9xFSrHK4Dl7W/?=
 =?us-ascii?Q?kob4LlHx0GCh1iC8IFyv0NquiFMf/T2yoH96f/d1u4dgL3H5ADGwfZBjv+6Y?=
 =?us-ascii?Q?hsyAkh6/5DjJYALmW0pnw9uCWAezNGG6Rb1hnUdrgIHM5550XntLLR0CeTSz?=
 =?us-ascii?Q?+9J80CcXhlQzFGVCDDGrYobE0CaZCWaCEzTj1gg1JwmztJjrluxbNk62JzfA?=
 =?us-ascii?Q?0wN5HHPZ9eEVXE1POuJTDC9zjYw5s4oDHigsGt49/8Xl1ra6vkI2MPmzoeyl?=
 =?us-ascii?Q?jd3QS0HsO4X54Vg0pqG4ATOgcU5CQ2T9lasjRFRSEMIrYXTYPp14ZuQBI/hd?=
 =?us-ascii?Q?dYW71yPwZseP2J5xndH+jz2pz1LhdOWoVdBJHeXxjvQL9mKs1Nkb+oN8X+4v?=
 =?us-ascii?Q?YkIInbvkvq2aWWlptQI5LrCn5EF87t+1WYoym+RdcZa4ST/2VXEdDFK7LBHr?=
 =?us-ascii?Q?N8HMsxVermIlgQOzm0wdvVKiaP2zygcFCoskT5q5boTs52wVTKeDQ1huR35l?=
 =?us-ascii?Q?VdttxVKoRd9ASQodeRjnyGfkXirPDfMyTckh5ndU5U6B/K95saPKrcaVJyrc?=
 =?us-ascii?Q?AQAuUmvTHpAQVNR5pZfX7ays9gHGD0WxHHFr6GCnoaIMl9LZJo2ZagEqeZZ8?=
 =?us-ascii?Q?2/OXjvthVwJQbGnAD+Q=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79b062a-e375-4c31-cfd7-08dbe1765209
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2023 22:50:50.2753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8kXZkLksFfm8zVWdIvEAFln9dAmZ2TfoOZbN9nh8iUquQPM/FlVSRkkjseeNCntkkax2huV4M4ZzyA33ls/fiu4roTna8NDCzRlpckR4Nao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_16,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090165
X-Proofpoint-GUID: p5Cny-CtgEwt7uQabnXc63NwiuL_yy0B
X-Proofpoint-ORIG-GUID: p5Cny-CtgEwt7uQabnXc63NwiuL_yy0B


Josh Poimboeuf <jpoimboe@kernel.org> writes:

> On Thu, Nov 09, 2023 at 12:31:47PM -0500, Steven Rostedt wrote:
>> On Thu, 9 Nov 2023 09:26:37 -0800
>> Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>>
>> > On Tue, Nov 07, 2023 at 06:16:09PM -0500, Steven Rostedt wrote:
>> > > On Tue,  7 Nov 2023 13:56:53 -0800
>> > > Ankur Arora <ankur.a.arora@oracle.com> wrote:
>> > >
>> > > > This reverts commit e3ff7c609f39671d1aaff4fb4a8594e14f3e03f8.
>> > > >
>> > > > Note that removing this commit reintroduces "live patches failing to
>> > > > complete within a reasonable amount of time due to CPU-bound kthreads."
>> > > >
>> > > > Unfortunately this fix depends quite critically on PREEMPT_DYNAMIC and
>> > > > existence of cond_resched() so this will need an alternate fix.
>> >
>> > We definitely don't want to introduce a regression, something will need
>> > to be figured out before removing cond_resched().
>> >
>> > We could hook into preempt_schedule_irq(), but that wouldn't work for
>> > non-ORC.
>> >
>> > Another option would be to hook into schedule().  Then livepatch could
>> > set TIF_NEED_RESCHED on remaining unpatched tasks.  But again if they go
>> > through the preemption path then we have the same problem for non-ORC.
>> >
>> > Worst case we'll need to sprinkle cond_livepatch() everywhere :-/
>> >
>>
>> I guess I'm not fully understanding what the cond rescheds are for. But
>> would an IPI to all CPUs setting NEED_RESCHED, fix it?

Yeah. We could just temporarily toggle to full preemption, when
NEED_RESCHED_LAZY is always upgraded to NEED_RESCHED which will
then send IPIs.

> If all livepatch arches had the ORC unwinder, yes.
>
> The problem is that frame pointer (and similar) unwinders can't reliably
> unwind past an interrupt frame.

Ah, I wonder if we could just disable the preempt_schedule_irq() path
temporarily? Hooking into schedule() alongside something like this:

@@ -379,7 +379,7 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)

 void irqentry_exit_cond_resched(void)
 {
-       if (!preempt_count()) {
+       if (klp_cond_resched_disable() && !preempt_count()) {

The problem would be tasks that don't go through any preemptible
sections.

--
ankur

