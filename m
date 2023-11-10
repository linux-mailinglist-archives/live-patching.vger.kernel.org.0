Return-Path: <live-patching+bounces-29-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15F797E7609
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 01:47:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24F851C20C6E
	for <lists+live-patching@lfdr.de>; Fri, 10 Nov 2023 00:47:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0CAC36E;
	Fri, 10 Nov 2023 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Chlj9xu/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qD4L4zM8"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2F2382
	for <live-patching@vger.kernel.org>; Fri, 10 Nov 2023 00:47:47 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE62B3272;
	Thu,  9 Nov 2023 16:47:46 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MY37O022455;
	Fri, 10 Nov 2023 00:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2023-03-30;
 bh=a+fXljtiRJNqE3gaeaVoPJdf31+ag0ThID329dG9eOw=;
 b=Chlj9xu/1yaY1zb9eflEkGy7PdVhiLxmlH7SAehhJvV3oHnvvceyQ8L/a8LyI+nSz2qY
 3ews9H4kLsM9Q9EbeR/yNay2hoIp6JXqqhiSxJladYz2LVJ1HkIyoxaGOvHIjdoJAvDT
 LsPasVTmzmGdOe3hpnX/YdDdLnRn+SBhytTDehgtIc68pfswZItBr9DZY0mxSvVvIQmh
 k6PD0AaQz1D/XEJcPa/F8nzsHN0QsJrwaJ2pdqHNeaDmgWzWo1fx66qn8aM+RUJSLFTi
 er12jjiaJ61eiALjCcOmSTPKC/OScx+2jICVVwMOQEe6Te2jcveobm+e04v2prwc3ZDR Qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w215df5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 00:46:23 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MQSMc011251;
	Fri, 10 Nov 2023 00:46:22 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1x7jsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 00:46:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpvpnGSYOsnd1UivavLl+T8Sgal1XGVy7c+ZfOddS/0AuLJ5QG00aQiyNr8lMlZt4QhCiETnOuS9gGTIwX14oi0eTP4OcqRrHrw1GwP5ineQ1Y59Fqic7yTaSYxrAleNWzaWjpV/9hI9e3mBdJbpx0xufLQIU2TzvbER0QOuFzQenvLM1VjiSFr74IYImQiTX3BIk3iJA8DVScD2CpqG2T5j6+PkKyq6tXVf081z31Dl7isMBdw36fc+By+pquY/IzAogsVnbaBCwT58pjVZeUk+yrsa2ji4SE+XZfWQNujAkD7lhEDPlKlJN98IFP/rr1N+dppnnRbC+Sxn9ExzPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a+fXljtiRJNqE3gaeaVoPJdf31+ag0ThID329dG9eOw=;
 b=CpYWAsotDWZXkh47Z5ftyihU8/GL8FHPuwEJMn1KbjREGR/OGrYh6BxpdZ09gO+F8WOT+TnaUOgFCfQ/GUlmYQEM9N/w3Dx/zkfDVymyGqspxfCfTwSUrif1RC/GhZWwdM6wZJhF84Llchdt4nCSsr02L89iB+dZzODZ0rSN0k0ulCxFVgMEKo9lAPNjSrq12LTK97FaGMLfQKPCWKATyFNXD00Eur1d0Rqp7OkYaFjcQw3d5WXPFFL5MllMY9hI7Dn1uJPzqJevUga+RpbqYZ1u1hTQLheUconaegZSMLCyK3ZoDmY91vi4YAa/IBrQp3gtE8T47YqOgqbBIt/LnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a+fXljtiRJNqE3gaeaVoPJdf31+ag0ThID329dG9eOw=;
 b=qD4L4zM8VMu6aODh8L3q2XVeQcAbORQPLRznFKSSxRP5cxcylJF6QoZmwnhRJ+5cyqzx/dvemW4b7qhPwHr68/h5RdrEDnn9rWaTw7ogb962rp/rGfAB/khFmqqETxcFrPI7cwU17rG0cEqIyN3DUe07ytVmwXqRSJ5dePIGz7E=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB7902.namprd10.prod.outlook.com (2603:10b6:8:1aa::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Fri, 10 Nov
 2023 00:46:19 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::10fc:975b:65bf:1d76%4]) with mapi id 15.20.6977.018; Fri, 10 Nov 2023
 00:46:19 +0000
References: <20231107215742.363031-1-ankur.a.arora@oracle.com>
 <20231107215742.363031-8-ankur.a.arora@oracle.com>
 <20231107181609.7e9e9dcc@gandalf.local.home>
 <20231109172637.ayue3jexgdxd53tu@treble>
 <20231109123147.2bb11809@gandalf.local.home>
 <20231109175118.olggitpaltz47n3b@treble> <87o7g2bkxj.fsf@oracle.com>
 <20231109234736.4kik62ys47ey23ju@treble>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>,
        Steven Rostedt
 <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
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
In-reply-to: <20231109234736.4kik62ys47ey23ju@treble>
Message-ID: <87leb6a10m.fsf@oracle.com>
Date: Thu, 09 Nov 2023 16:46:17 -0800
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0234.namprd04.prod.outlook.com
 (2603:10b6:303:87::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB7902:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c9521fc-8817-4036-e55a-08dbe1867432
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/OOCh7BZT/Mn7irl/3dpaj+adHwyJJQqV9hm9oqUc5GMJxn6r5pzadCYN7T33kCfaJdTpDDrbnOiqlhBiaawpD9zBqoQ7IFPfE/mnUJDXwc7yVpQMBder/BZN5gxJpMVG7KN92YIdmvgQy6GEfqU+KZzf+ZTeUJ9r1X7IjBxUdchyv5s7REEN3zZI5vbzY4DSxYvu18UI6OOUH/p8lI+4ig4PnvAP3XtNuCabsv1i9B7QgUb+LhDepqD+6ZMPMv6O2vawMA/D6uw93TYeYMQ/bvggbzJmK0Z+jOqrlHIa5HVmuJzxSqjTRTTTSdnqNjy5VlojQ8kGxfR0mac1vfMNyLMqgLI6simOmHucwZOwEwPPyP8dsIEvCpEGtgzdu0KdXAu0P6Lazh3VG7aS1wX2tZzy9BnSGf+dd4WEVxf12n2cjLYyK1JuFrlcPFbXXy5FY57l2zf4jPgP/SZtLNzqfKx3M224sjAgYyPN/iKk1H/KhMsinGyPby41jDCXcxRT3uvWyHIrQUK0JVLWoDM9tVVxHfAlsQYOKVap0v8AahMjo27QG4DMDpeo+Sp1OwK
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(316002)(6916009)(66946007)(66476007)(54906003)(2616005)(6506007)(26005)(6486002)(36756003)(6512007)(478600001)(38100700002)(83380400001)(86362001)(66556008)(5660300002)(41300700001)(2906002)(7406005)(7416002)(8936002)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?4NUf7UVZ/Qnwml1yRqVJ+uKvIsMRbEdp0DeyjriLly2a4DULsEa3Uzr5s5X0?=
 =?us-ascii?Q?CW/kjBmw0m+XNK/lo9qTAslNUre59YU9lTYNosuk6Q5WAFrS1FTEDFtgdDnK?=
 =?us-ascii?Q?tWotn8KZqkhHN3ut+7E/AISNbNCLC7gCulQUiDkxFHo7GGuDoOyo+pnWEer+?=
 =?us-ascii?Q?bccQZ+0JmN4tbKWfUA5gp/ICUss9KBFDi5tLPSnAeGS/MXecVgTYt953JaX+?=
 =?us-ascii?Q?DjRl6vB//u78+nZK2yovOtYq77PYyK1fKyL7dm5refZRm9pgZhFUQnAtu6eo?=
 =?us-ascii?Q?BNWVCtvWTJm5HzELrHPIPijv/b4r89Wc74yCDL2MRCKlY1zHN7qUd3rKyiM7?=
 =?us-ascii?Q?HZKrsbSGOTrDcbR83c0xxgAN0jb2D6VutofdgIVNDGEO6uXC8Q4QXIb1LY4b?=
 =?us-ascii?Q?NdP6Bq/hBzDzV6WPCcXxun3XTtxkEOQPnhRUZd7IC53AaOmrbyLrrxJxXKWv?=
 =?us-ascii?Q?CdUCiuMcIvOqqIIxvIJe5gsrrxm+qAPqfAlbiZnMkC4HCYs34wH4rAJvzENY?=
 =?us-ascii?Q?8AHoVAiiuSQOU7DgZikS7gxmxGgEoSf2Y5OLQjoRV1fqLJ34kbefsMQkVmGA?=
 =?us-ascii?Q?5Gm0lmcBKpIwIjyoB2isu6xn2STdj76/RetipMkJTIpedIbQ4xm53Ufmlq9p?=
 =?us-ascii?Q?zaU9fVaBPi7ObyVvURaoYjVaBHM/keL9N6IVK1oTvMc/g41UtjqO35pM/4Mk?=
 =?us-ascii?Q?ho0akA3pCOdYDR5/HQwzIuCzSUy1Uxcau8PFwcE3O5L3IQEAkmIYzcBqFbv5?=
 =?us-ascii?Q?SnlgiS7QlPuulCIPWo0P/qMokd4fd6gYenJG28lFsBXFoGQ6YP9AmCd7hlT8?=
 =?us-ascii?Q?z0wzAW71we5IVIICy8RAbPK3UhIhf152ZNjdu9/U3UNWKheLURdza2Wz3CdC?=
 =?us-ascii?Q?1fyiEB0Men51Bspsu4upXLRsD5dpgr3NTc+6xKeDeyokH+MRyxBZQRX6Z29U?=
 =?us-ascii?Q?2C6IQ1uFj+iBYKhAJGSAIwdSEy+bCQ2AaBdcuPxYiaS67igv5sDwrdxAYc0u?=
 =?us-ascii?Q?UnDgnDE6hiR0ubUW7WTqRt9MfBL0qnH3KQGPV265l32pn/Spgc3LNkdbyalu?=
 =?us-ascii?Q?nfGNnHJQvh3NTkZwjAwdWVYJCGESZHfZltcoqj2rFlFGJ5pMxDV4HCd6p7FR?=
 =?us-ascii?Q?pQkJdRK4XHXdyBSr0Hu5TnKVMXDREbuwvsBNAoK5nxLnv8bzPSAfW40Y1N9Z?=
 =?us-ascii?Q?QjE6ktk95G4DLvS4MSGQpV/n70EkJ4bgt+uiQRwGDOxFvDUk9uLft3U4ELZm?=
 =?us-ascii?Q?yD7v0S7IUB2m+7q2XlDpyTB89iY1lQTBPoxEVvTMyAYaDA5b49v1MMx6cdIS?=
 =?us-ascii?Q?6D6ESwq8yssry3q8cyWn7VqnyjfR+xyy397EyvjFbc0/heyNwMNfXSBcfroP?=
 =?us-ascii?Q?8tgk/zHxkqXXBfi1d6Y3lxih1CM0mvw/QPNvkeR6kx13iJEA3SXM6U64Jtiv?=
 =?us-ascii?Q?vzKfyeUCCn+lrAEwJLHTVQNWAogG1d+bGYWUacHvG0cMldwCVrNJ4nMGqGuA?=
 =?us-ascii?Q?kQvBk1mxkttgB3In5LDJOlYYxSHBEt2uV+mSJxKqioG2iP4xeCrsX+2L9ltu?=
 =?us-ascii?Q?KcPXj0rH2EV/gEHH5mFakc2lzpRAEbWm9HOmnp8W?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?ycGpvsyytAQ5VAjZgoUEANktMX/IkNl9OuqOliyOzIKLF7t06bZB619WFGap?=
 =?us-ascii?Q?PWtRUrs72mDJpVVDRMaHm5hXuISS7KnKTLBuBa8w4dFkgj+Lmq+TEAF9T2GJ?=
 =?us-ascii?Q?FaRLObjz8Uk05l9h+n24nYLo42KYDt8LpnjrS83pvxUwrah1M1IHgV27V/9E?=
 =?us-ascii?Q?LG6k8/vocU+ZT75vqcKPZ7rgZadUPPd+G/ptG/mAsKJZs0EN5t85HRwRul8l?=
 =?us-ascii?Q?G7kSY01biGInlpwFPxU4zVAG7kfMXSc0k1Apf1tVrNxXSUDJds8UY/vTHtlB?=
 =?us-ascii?Q?4Ue81PRPcJOJwMICzMVerk/t6/uOVlW09OLiPLOtJYQxUySHMltwuyw6BTpb?=
 =?us-ascii?Q?Ng4yhwsSUhk9hYIgmDDPva66IfOAHU3druclSsDQTHgSbnyklRk0I5SrLK+R?=
 =?us-ascii?Q?cBsDN9QeOgJZzHAeJ5G8zZJ5BaDj4s8wFa4edI5LBs7VHSHgBvt2Id/8f4PX?=
 =?us-ascii?Q?pOWJyR1KC+ugXQLCLcCn5MHbY0ZGnTCahJD9aCcnsvJ4EWO7axLE3m8Y+EkQ?=
 =?us-ascii?Q?NfWLya6WaagYTcaLiJi5tfCcWMpJ2tP8LRmRhnUpGhO+Ic7ZBdUTClU4ngp5?=
 =?us-ascii?Q?Kt0gDs3puIw4tFOZnPJloPizGvygxzP0SiU2csuTqs78EO8yilx/eufIkgFx?=
 =?us-ascii?Q?y03uz54G/G0R0kQLi2FhEdeOhJ2EVAPdk8P9807u11J/9U89LETnB/Vk0GCi?=
 =?us-ascii?Q?NOviNWdZDcAUnUu96OkH2mncEp0gTwKbxOGbnXvnEyl/gtxFVbEmSBzmbk5P?=
 =?us-ascii?Q?ABBBE+/pD9YDvorhXQYH7VNEHnuzgtdwDcCYjVBaFr8FYrdNlM8LkN8gFCJV?=
 =?us-ascii?Q?IIFt6vfR3/lhnOKyEa8OtnDbea2/msMA7lYVtV6rqHuslRho04mCDNVojrTZ?=
 =?us-ascii?Q?VMCX0NDRAmYMrvAhWdpBkuCoKUd0K4ttFr7TCJ38G2SVuPSIvBTks7S1ZGUR?=
 =?us-ascii?Q?j5thEuqIi4mQGsA/Dc4xsg5hycaSmq1m+MaDdNdOZrRIH6arqWQ3hcAcqj3W?=
 =?us-ascii?Q?p7qBneb2eHtL6sjPBuQtxwO534fbDPaG0TzZL+lbMeCji0gNXEGuXHFj0Cad?=
 =?us-ascii?Q?WpCTWF+RC8v1BpM0Skj3gccOR0dGCqGkCdfNJOh2bdMIGZhSzk0o0nllPi+6?=
 =?us-ascii?Q?N9PHkHxctPGm7bvkDS9nH+w5uMV07H7fgfEPirWdBcJ9xL1M4EXvCXCMFAyf?=
 =?us-ascii?Q?uWV1eJQNplFvd7L0150vImDCANQzqVPPxidNm5HOn5kJE07zid8IYqwCKJCB?=
 =?us-ascii?Q?uj8UK3tMeCsg8fOc+y2fmpmj+b0WAI18L4qtBJlx8jc9+1rmF7d0WNDscqMU?=
 =?us-ascii?Q?EfoRVnZZALLZlr8+lfxt5T1au1BW1WEh9ZjT+Z+yNvyobvTC/NATvXob67kM?=
 =?us-ascii?Q?+7NOP1k3ZQxcky2lyo9qc8qTerQ8uRbndO7fthcgvH1+a5XE32eMUrXMnt8S?=
 =?us-ascii?Q?iNA8fzNcq/r8B8Ruhd5JVu+vXIotdJtUcCkZuGhTKVPH91WbHXOvjN7pj273?=
 =?us-ascii?Q?nukDBvlmo3X8GxDioQRgBXrKyPt+S2iLHXbXuyvoqak/kLLDK8B4hIsxMmRa?=
 =?us-ascii?Q?QchNYRTbBz2yD1Vr0wQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9521fc-8817-4036-e55a-08dbe1867432
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 00:46:19.5787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYVCYin46uJZ7XE6Nklbiv1mahnmiG2/KsTnlPuIIcdjzVY2iWHC4s8ZzXvXPv+y5ax2bZ1NOAE3JG7JZvz59mXZOUmMGea5Qx8prCS8Trc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7902
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_17,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=906 bulkscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311100005
X-Proofpoint-GUID: ZQoEwvGcOy18TKHoFt2rE-7c9_DxpQLy
X-Proofpoint-ORIG-GUID: ZQoEwvGcOy18TKHoFt2rE-7c9_DxpQLy


Josh Poimboeuf <jpoimboe@kernel.org> writes:

> On Thu, Nov 09, 2023 at 02:50:48PM -0800, Ankur Arora wrote:
>> >> I guess I'm not fully understanding what the cond rescheds are for. But
>> >> would an IPI to all CPUs setting NEED_RESCHED, fix it?
>>
>> Yeah. We could just temporarily toggle to full preemption, when
>> NEED_RESCHED_LAZY is always upgraded to NEED_RESCHED which will
>> then send IPIs.
>>
>> > If all livepatch arches had the ORC unwinder, yes.
>> >
>> > The problem is that frame pointer (and similar) unwinders can't reliably
>> > unwind past an interrupt frame.
>>
>> Ah, I wonder if we could just disable the preempt_schedule_irq() path
>> temporarily? Hooking into schedule() alongside something like this:
>>
>> @@ -379,7 +379,7 @@ noinstr irqentry_state_t irqentry_enter(struct pt_regs *regs)
>>
>>  void irqentry_exit_cond_resched(void)
>>  {
>> -       if (!preempt_count()) {
>> +       if (klp_cond_resched_disable() && !preempt_count()) {
>>
>> The problem would be tasks that don't go through any preemptible
>> sections.
>
> Let me back up a bit and explain what klp is trying to do.
>
> When a livepatch is applied, klp needs to unwind all the tasks,
> preferably within a reasonable amount of time.
>
> We can't unwind task A from task B while task A is running, since task A
> could be changing the stack during the unwind.  So task A needs to be
> blocked or asleep.  The only exception to that is if the unwind happens
> in the context of task A itself.

> The problem we were seeing was CPU-bound kthreads (e.g., vhost_worker)
> not getting patched within a reasonable amount of time.  We fixed it by
> hooking the klp unwind into cond_resched() so it can unwind from the
> task itself.

Right, so the task calls schedule() itself via cond_resched() and that
works. If the task schedules out by calling preempt_enable() that
presumably works as well.

So, that leaves two paths where we can't unwind:

 1. a task never entering or leaving preemptible sections
 2. or, a task which gets preempted in irqentry_exit_cond_resched()
   This we could disable temporarily.

> It only worked because we had a non-preempted hook (because non-ORC
> unwinders can't unwind reliably through preemption) which called klp to
> unwind from the context of the task.
>
> Without something to hook into, we have a problem.  We could of course
> hook into schedule(), but if the kthread never calls schedule() from a
> non-preempted context then it still doesn't help.

Yeah agreed. The first one is a problem. And, that's a problem with the
removal of cond_resched() generally. Because the way to fix case 1 was
typically to add a cond_resched() when softlockups were seen or in
code review.

--
ankur

