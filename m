Return-Path: <live-patching+bounces-871-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D74739DE6C2
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2024 13:58:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2927FB221B4
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2024 12:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A261B19DF9E;
	Fri, 29 Nov 2024 12:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G07qwqKt"
X-Original-To: live-patching@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96E319D098;
	Fri, 29 Nov 2024 12:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732885087; cv=fail; b=AfOzo4PP23HfKcugbqRpjB5x0Cm1Jogx/kF1AOmE+jvbeOo+d+rtpLPGCUGQZmHGLeGoNhIMn4LzhuFGleZ9+hhTygkbUanzU9Kp5p1WcXvemImPyMW4dljbLc+bg/yvy+FUAIRNOVPnXT5yefsjmM3rfgsiApl0q2+nEq9KuUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732885087; c=relaxed/simple;
	bh=weL3piMTjoNujiNid4RDogwwA/DCEKj+1u5pMzDG49k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=b3FAs7E6TnurYONqc4J6le3CwCcvu/Bz7XZj/7H3kJBB0LNGWOLKXN3bHTvsMwJ53to3P7YNZU4NEwneQtGBZ0LlRdtNlDBqEReWOHlF4X2P/pJ5MV4/NcCdv84dVW7OK+XoAhUYbsPbH8d2/pgGcdiOqPrSka5EWLDDtuD6SSo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G07qwqKt; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732885086; x=1764421086;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=weL3piMTjoNujiNid4RDogwwA/DCEKj+1u5pMzDG49k=;
  b=G07qwqKtG+z5vgkkyA8yT6aMH8uoMXGhr4X9pnSjBLzHGdVZFE6noSKa
   u86u8WjhB0tjMK4dsimpW9JfiGAWNwHdkAG56q4AohAQ/vl8T4bkJ8BcC
   N+FceARtUQGQZl9BO0DgSPSLF9E05V61nMewzmxmF+R0MNEyDW91GmMti
   HAc7rPzoKbVNnVrfqR9GnGxArciYLzvpBJIVNgu3bzU+ax0UaVLpUeukm
   oeBzh1KRmRVF8wxF5tC4mtSxVzMluI6DSps4Kro+bBDUf3cGTBiT91CKc
   wRoCSZ/doNlj3YQlCGSAlVQqP2yV8o4Hja7uEKbc4XVa4QfijBVWyGuh/
   Q==;
X-CSE-ConnectionGUID: slLDaV0mRO2caP4Z9mURKQ==
X-CSE-MsgGUID: ewuHcardRi2bH6XSJdeK6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11271"; a="33054650"
X-IronPort-AV: E=Sophos;i="6.12,195,1728975600"; 
   d="scan'208";a="33054650"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2024 04:58:04 -0800
X-CSE-ConnectionGUID: HAvQQNW/RNWOl4aOfrc//Q==
X-CSE-MsgGUID: QKzxRDpsRp2+YRSgSDDPkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,195,1728975600"; 
   d="scan'208";a="92593314"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Nov 2024 04:58:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 29 Nov 2024 04:58:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 29 Nov 2024 04:58:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 29 Nov 2024 04:58:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=quCbtJ24tWPmPATmSXI/wOXpATuCaCo0hIr9k7ZcwEZewHb/EuBWyTInctB5QwhSROxmEXN3PiwxGX687e7QwCYxAlBFD70gzdNI5a8r7uNBpjJWZqy9uxCqXKbkTFYWqlm7HzQFc2+yE9/f2BbXDBXPre1STezTtXrVQpV2vaJOZ/1nNyvtn+PSE/1JAAqbG/bkxJG+ApYSq82+VTLWjkX1PcITcSpGlfM0J8Rl0y6X35x1eEQM7RI77zmYQHh5gixrXJqrvrpBxim9bIJUMU28zFs1eWDnsxbKwG0fhFcgSoOfMvE+Ro/5A5OsQ5rKCZr4/tJg2yF1pLgVvvEmcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SV+OufASk8xBhFc+yWg6QA9nU9jS1Mod881QXXOOPQA=;
 b=lJRjYzW7QtP0TJ254CvUOkjztPHqGJmr37Wdd1gmdGN7C2dILYcW7EJsd+41ncfJ1q1qHgmJaGY941JBQJOQiPEGlP9tIexdimvDINiV0Wrm9lg+1ZXYDtdx3QnJPejJ6MA6mxT5sbz+WQthSO56tiBrHYLkVhwJtZCB1Go351VQJcKLR/tCNEfmn1rGlmykc/coPhXRCHztsFeZMPpe4kLsXEYN1OWauVRPxDYj+UxE45GOZm1+E7DFSGg2TStYKLnOVDNTSSgr9W/BUx+7vo9kkTrBXxAW5PDSt5fcnRAJo/tfwcjW+AUjbhXBZ/MC4Yhl76E8g8JFTWGgqYCT+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9)
 by SA2PR11MB5147.namprd11.prod.outlook.com (2603:10b6:806:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.15; Fri, 29 Nov
 2024 12:58:00 +0000
Received: from MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6]) by MN6PR11MB8102.namprd11.prod.outlook.com
 ([fe80::15b2:ee05:2ae7:cfd6%4]) with mapi id 15.20.8207.010; Fri, 29 Nov 2024
 12:58:00 +0000
Message-ID: <b9fcb12a-b7a4-4c33-836e-67109ce07deb@intel.com>
Date: Fri, 29 Nov 2024 13:57:52 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/21] Converge on using secs_to_jiffies()
To: Easwar Hariharan <eahariha@linux.microsoft.com>
CC: <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <cocci@inria.fr>,
	<linux-arm-kernel@lists.infradead.org>, <linux-s390@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <intel-xe@lists.freedesktop.org>,
	<linux-scsi@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
	<linux-block@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<ath11k@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-bluetooth@vger.kernel.org>, <linux-staging@lists.linux.dev>,
	<linux-rpi-kernel@lists.infradead.org>, <ceph-devel@vger.kernel.org>,
	<live-patching@vger.kernel.org>, <linux-sound@vger.kernel.org>,
	<etnaviv@lists.freedesktop.org>, <oss-drivers@corigine.com>,
	<linuxppc-dev@lists.ozlabs.org>, Anna-Maria Behnsen
	<anna-maria@linutronix.de>
References: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Content-Language: en-US
In-Reply-To: <20241115-converge-secs-to-jiffies-v2-0-911fb7595e79@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: WA2P291CA0045.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::19) To MN6PR11MB8102.namprd11.prod.outlook.com
 (2603:10b6:208:46d::9)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN6PR11MB8102:EE_|SA2PR11MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d5165e-3df9-44c0-490c-08dd10757449
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dkxVcnZ6ZG1sM1ZPYjdBekZPRHhJMzJOVDlWdVc4Lzg3T254OEFXSFVEbEV1?=
 =?utf-8?B?bitJLy9YVHdIeHB5Q1o4QjZVSzJZcDFHem5rTXcyMnF1VTFvU3RiQ3BUNVhy?=
 =?utf-8?B?TlZhckMvZm1GSXNaVm1ra2JjWklJM3MwWUQ2eEhSbENQa1ZSa3VXMUN2QUhl?=
 =?utf-8?B?aXIxZWdpejRINDMvb1dwM0Z1UllBQUNad3lzMEliTGRva2lOUFV3WjZrNjN2?=
 =?utf-8?B?Y1V2dmtWVmV0ejBzazAxcnFBcHpCSXpzcE9Vam1UUkEyQTRRM1pVeGYrbDJS?=
 =?utf-8?B?RkpOSEgrMEhLNklaMXJJazdSbUVFWEVoSWdsaHluQkNRWVd0Um81ODB3WS9O?=
 =?utf-8?B?N3c1a1FEejgyWkVyemxrU1VXMkdWMmF2RGtFTFpoNjNObFpMdVAzaytNU1RL?=
 =?utf-8?B?OUZwd3ZBVTk5RG1BdHNKOUFEV2JPSXVuVGdMOVY3Q0NJQmZPTTNGdUpzRkZV?=
 =?utf-8?B?NFpCTnJndkNSRkdNNzc1NzhkVzN2Z1poaGtBcmVkdElHOGpSVHA5UFlCKzlG?=
 =?utf-8?B?M3pjMUovRkxnZ2wySlFteHRqTWRhRFBHUzBiazJCcnJZZ0xSQmNPdDlQcWlz?=
 =?utf-8?B?ZWFMb0tkYU9lcFRQTjVJN2ZuZmIwb3R6K2sxTW5HeEg5RGFMUzFraXhKZVJP?=
 =?utf-8?B?bFl6WkkyU0NOL1g2OFBTVUUrNEhJc2d4YTZnRHl2em9kVHZNZkRFQnVQSFRX?=
 =?utf-8?B?bDNjM2NndjB3WkhITmtMb2w4U3NNSjZRdE1XRUNMQjNVejEyQkdhaUtnUWRk?=
 =?utf-8?B?Vndia0hpeFFUaERTWUtjYWdZK0c5d0NHelZPNFRpVWNmd0ZpVmVUNk5wSUx0?=
 =?utf-8?B?QW5DN2xLREVFaXRlZWJ1Tnp1RDMwYS8yN0ZZempwbXhudzNJUE5vczhuZ2N4?=
 =?utf-8?B?UTJya0tlYWcrM1ZNdWI3UFo5WHo5QTE2bUhvVi9ITXpSOHdlczREY1FodStv?=
 =?utf-8?B?QXR6RDdheE9NSmNHTVhJV1RMNk10djE4anhhL0I2dnhveFZLNkhuZWw0ZndJ?=
 =?utf-8?B?OEhNK3Z4SGtDVHZHeCt2NU9SRjdIMEl2MWRBVGFpV2NpWlpIMmY5ZktTdlY5?=
 =?utf-8?B?L0RHL0tTdkNGRUl2alA5VW1ROUlLWnRUSTdNMXB2YkVVa3NIUDZKckNaWG1I?=
 =?utf-8?B?cmdvaEJYVWYvdWFIYVYyMCtKeGY4RGpVb3hjbDVqblVHTU1mQVd2djNCaGFV?=
 =?utf-8?B?QnZTaDlSWGtyVjJTL0pvQVRjc282VFpMdG0xVVUzb05PUit3VG1SVWN3T0tP?=
 =?utf-8?B?VldMMG4zdk1BZGhUVjZNZ3YvVVZaNFRIZkx4MHk4YXF2QTg4U2pUWlRXdS94?=
 =?utf-8?B?VHp1VFFXNEU1elUzQVJZbWNTcS9YOWlLcUwySzhZWDd6aWRRcUMvTVpzL1Bq?=
 =?utf-8?B?ZEN2anZzNEJVMmQ5Q0xpbW15cFdLa2NiM2RGYnZvZU4zSmQyaTNkS1VxMENx?=
 =?utf-8?B?WWprTEpoVkg1WEJrQ3Z2SlpEOVA5dXdkY3p4NnBWNmhBYlpnZXFWS3V4dmVy?=
 =?utf-8?B?RDlyQ2ZrZ3B5VlR2TkFOUWVqb0NJT05UazByRlRoUnJIbmNYNi8xTk1WM0Zt?=
 =?utf-8?B?cExlWS85VWJiU0MwaDNPQnBXMTc1ZStybFY5SkNWSitvUXh0cUFObE04R2pa?=
 =?utf-8?B?NlZMalFXWURBaDgvdFpISm9yVHFGaStaUHlHckJWNmpxVUhObVMrcnV1NTU1?=
 =?utf-8?B?anloQTgzZllIUFVLYmZnYjJYV3kvMUJqSlJ1M3BtQ2orbnlsRzFIK2hMN0or?=
 =?utf-8?Q?kqlUCgrkXGW14PGqqE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN6PR11MB8102.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzBicjlHQkRsSklUZGpsMVBLRW9WOUVoUUxVMTZLREpncm9KZGhPN2hKa0cx?=
 =?utf-8?B?S1NHZHNaKzJjM1ZleElOVjVPSkh0eklmRFY1enpxWk9TUFlnbkoxeGdzMXNn?=
 =?utf-8?B?NFVjTks5ZjZCRndhR05rTzBQQmdaM2FBaWNGK29wOTZmc2gyS1JWdlczQzZo?=
 =?utf-8?B?OFlSd0FUQVBtaGNzak1nbHQ4cFZVRDNvbDB2Qm54RURlOEZEL01xN1JTMFRk?=
 =?utf-8?B?U1NOSDE5UTdiUWl0TjlKSG96eUtPQ1lPL2Z0Q2dUSFRBQUNTeWdkSHY5YTBh?=
 =?utf-8?B?cVNRZys3RXVTbmJkdm01VExFV0tKaW1NbUdDUDhUZzk1VWVWTkZEcWo1aU1o?=
 =?utf-8?B?cGVJY1VuMmdZbmtxaHQ2UC94OFBhVzRBOGJCbzk0b0FCcDd6UlliQnFBaXB4?=
 =?utf-8?B?ZUhRb21KZ2VlNG9FTjIvUGxxb3BvUnM0Tk00NUlsQzN1NVFIcHFZaUxHVGtG?=
 =?utf-8?B?ZitGeGtHR05mMzd0M1Y5QlpPLzlqTlFMR2xrbjhjTW5OdndkL3lGM0lQNkhP?=
 =?utf-8?B?MEdwZ2FPTnc5Sm85Vm5pOFRmTTl0akdlRFhIR2h2bktZTFBFeHdsQ0dNUlI4?=
 =?utf-8?B?S3dDUWJUM0xoRVZ5R21TaUMwelozRGdkVzVzemhTTFBTOWxnNTUwSjdVcUtj?=
 =?utf-8?B?Q2VQOVZEWXYzQWJpd0ViQnpwR3I2MWVkVkMweWc1Nm4vWkhBVzhxQmFzczA1?=
 =?utf-8?B?VTJ6NVdoeGVuZ2dOQzlWQzFYQ1c5UStNWHVhRmlzbGlGS0lERVFaSFFxUUpI?=
 =?utf-8?B?cURYMEs3RStNbCtMZmlJNDhzVjlhTjFwRHdzZjlrYlR1S0I5RkVYUDhKbXk5?=
 =?utf-8?B?Tm41ZUhiMnlQZnhER0w0NU1GM01FWGxJSHFUeURaUis2Tng1T1Z5a04wdUJM?=
 =?utf-8?B?MWxVbCszdk42UUpZM1pVMWVZQTFzc3pySUlzOG5WN2tXZm11cHZmUG9Ddkx1?=
 =?utf-8?B?SmdmbFVJMnljR1RQam1xR3BSd29oYmJjcGZNVU5qL3hzYUtMWTN2UHBrMlJ4?=
 =?utf-8?B?d1ZoSmFrVU5GQXc0N1J5Rm1HeVRwSXVHUGhXOHhIWW1lMkYwNTFudFlwMUlz?=
 =?utf-8?B?bzlzcENOblQ4U2k1NTRLeGoySW9pdmJZZjIyL3dwQTdvaGk1cnUzUE5yeUdr?=
 =?utf-8?B?OVRSWDNIZUgwMkd0UmZ4TFZnNzhpSitJSm8xRjB4TUcxbVl3cmxscDhZNzRI?=
 =?utf-8?B?cEtYLytwY0h4RGJOY1d6U01PYVI0cUh3Vm0zOEhsV2paN2U3VTZ5TTNwS2F0?=
 =?utf-8?B?Q1I4OFlpMnY3UjV0NXVVSmJiYzF3bklpVlJOMW1Wc21NZVc3ZXdTbzBBUHp1?=
 =?utf-8?B?KzluVlN4UnFPem9PZEZhODI0L05BNWVZRnBkbVZCU1Bkb2JYQWZVRTZObGcx?=
 =?utf-8?B?ZFpTNzVZZXdBVEtSc2o4YzdXdXRnY2p0b0tLTzFVR296cEg3ZkFlYVAwMXc0?=
 =?utf-8?B?Z1lka1lNQjNHZDdISXNCQTFXRkRiWkNFWk9SbmhvRkJSSlRLWWRGaWFtTllq?=
 =?utf-8?B?c3plVkVtRTB6ZGYrSG9KbjkwOXB4a3h6cnNVc0FZWDhNVUV3ZDVGcVRsRW40?=
 =?utf-8?B?YjhQeThqMkYwQzE5dHpWUDg5cmVObE1DRGlGL0IyMWZCR1ZrYU1SYmY2eUUy?=
 =?utf-8?B?VVZNTmpRUzRnc2FnSEVIbEJidmFGdEVEblExcVJIV1RnR3VEOFpxTEJoZmlk?=
 =?utf-8?B?NnJXTmZOWXFVV244ZzFhSHhQUGtKaHUvcUptdzJ1ZXRTRlM2djdxaHFwZndM?=
 =?utf-8?B?VUlMTjJBUS90ME9EQUhVU2tHcVdrTFYrWjVWNkZsWGNyRjAyc2JSUUYxY0tj?=
 =?utf-8?B?c3RKZ1pFenJ3RjZwWUJtbXpKQmhxWXBpUlRIR3ZXUnVqWDVVVlplbmtUZTN3?=
 =?utf-8?B?WHZld1VzY2pQWnNyeldBV3FHM2xobmpiTC9rM29IS29yaVJYYWJScnQwdHNY?=
 =?utf-8?B?SVFXa1czanVTdlg3Ny9leFlURnRqUGVDZHg5U0Vrb1c3TUdwVGlWdFlYS1Z2?=
 =?utf-8?B?RFVSZzlOMk91N0ZrU2F6RGQ0ZkRvdjJzRmdIRVZMeUd4ZUQxRHp2NXl4d1pU?=
 =?utf-8?B?YXdBaXFGUGUvR3BNOUF4c0pGOE1FQ005eWd1Q2ZaR1FxYkFLc1krYWFtTjk5?=
 =?utf-8?B?anFqOG5TNWNyRlZJR3N5UGY4bmtsVHRNRjA2S1pvbzRtNVhqYmNvNUVRNkhn?=
 =?utf-8?B?T0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d5165e-3df9-44c0-490c-08dd10757449
X-MS-Exchange-CrossTenant-AuthSource: MN6PR11MB8102.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2024 12:58:00.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7oJDD6qW2ylePjbQiFLukqf725XNvKEjJdGC96Qc7GsdtHc8H4mr0M/UZyhXA11t6B6X2TWAYoqh/Ueo1h3WJ/GmLtyX9JwWT9WrZpqkg70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5147
X-OriginatorOrg: intel.com


[removed most non-list recipients, it's just too much]

On 11/15/24 10:26 PM, Easwar Hariharan wrote:
> This is a series that follows up on my previous series to introduce
> secs_to_jiffies() and convert a few initial users.[1] In the review for
> that series, Anna-Maria requested converting other users with
> Coccinelle. This is part 1 that converts users of msecs_to_jiffies()
> that use the multiply pattern of either of:
> - msecs_to_jiffies(N*1000), or
> - msecs_to_jiffies(N*MSEC_PER_SEC)
> 
> The entire conversion is made with Coccinelle in the script added in
> patch 2. Some changes suggested by Coccinelle have been deferred to
> later parts that will address other possible variant patterns.
> 
> CC: Anna-Maria Behnsen <anna-maria@linutronix.de>
> Signed-off-by: Easwar Hariharan <eahariha@linux.microsoft.com>
> 
> [1] https://lore.kernel.org/all/20241030-open-coded-timeouts-v3-0-9ba123facf88@linux.microsoft.com/
> [2] https://lore.kernel.org/all/8734kngfni.fsf@somnus/
> 
> ---
> Changes in v2:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.
> - Link to v1: https://lore.kernel.org/r/20241115-converge-secs-to-jiffies-v1-0-19aadc34941b@linux.microsoft.com

that is not a proper changelog, you were supposed to edit those
placeholder entries; please look around for examples

There is also just too much recipients. Please split up your patches
into smaller pieces. You will also learn the process on a smaller
sample.

And definitively please wait for 48h before reposting such big series.

Regarding code - you could also convert msecs_to_jiffies(const * HZ),
there are 10 that are greppable.

> 
> ---
> Easwar Hariharan (21):
>        netfilter: conntrack: Cleanup timeout definitions
>        coccinelle: misc: Add secs_to_jiffies script
>        arm: pxa: Convert timeouts to use secs_to_jiffies()
>        s390: kernel: Convert timeouts to use secs_to_jiffies()
>        powerpc/papr_scm: Convert timeouts to secs_to_jiffies()
>        mm: kmemleak: Convert timeouts to secs_to_jiffies()
>        accel/habanalabs: Convert timeouts to secs_to_jiffies()
>        drm/xe: Convert timeout to secs_to_jiffies()
>        drm/etnaviv: Convert timeouts to secs_to_jiffies()
>        scsi: lpfc: Convert timeouts to secs_to_jiffies()
>        scsi: arcmsr: Convert timeouts to secs_to_jiffies()
>        scsi: pm8001: Convert timeouts to secs_to_jiffies()
>        xen/blkback: Convert timeouts to secs_to_jiffies()
>        gve: Convert timeouts to secs_to_jiffies()
>        wifi: ath11k: Convert timeouts to secs_to_jiffies()
>        Bluetooth: MGMT: Convert timeouts to secs_to_jiffies()
>        staging: vc04_services: Convert timeouts to secs_to_jiffies()
>        ceph: Convert timeouts to secs_to_jiffies()
>        livepatch: Convert timeouts to secs_to_jiffies()
>        ALSA: line6: Convert timeouts to secs_to_jiffies()
>        nfp: Convert timeouts to secs_to_jiffies()
> 
>   arch/arm/mach-pxa/sharpsl_pm.c                      |  6 +++---
>   arch/powerpc/platforms/pseries/papr_scm.c           |  2 +-
>   arch/s390/kernel/lgr.c                              |  3 ++-
>   arch/s390/kernel/time.c                             |  4 ++--
>   arch/s390/kernel/topology.c                         |  2 +-
>   drivers/accel/habanalabs/common/device.c            |  2 +-
>   drivers/accel/habanalabs/common/habanalabs_drv.c    |  3 +--
>   drivers/block/xen-blkback/blkback.c                 |  2 +-
>   drivers/gpu/drm/etnaviv/etnaviv_cmdbuf.c            |  2 +-
>   drivers/gpu/drm/xe/xe_device.c                      |  2 +-
>   drivers/net/ethernet/google/gve/gve_tx_dqo.c        |  6 ++----
>   drivers/net/ethernet/netronome/nfp/nfp_net_common.c |  2 +-
>   drivers/net/wireless/ath/ath11k/debugfs.c           |  2 +-
>   drivers/scsi/arcmsr/arcmsr_hba.c                    |  2 +-
>   drivers/scsi/lpfc/lpfc_init.c                       | 18 +++++++++---------
>   drivers/scsi/lpfc/lpfc_nportdisc.c                  |  8 ++++----
>   drivers/scsi/lpfc/lpfc_nvme.c                       |  2 +-
>   drivers/scsi/lpfc/lpfc_sli.c                        |  4 ++--
>   drivers/scsi/lpfc/lpfc_vmid.c                       |  2 +-
>   drivers/scsi/pm8001/pm8001_init.c                   |  2 +-
>   .../vc04_services/bcm2835-audio/bcm2835-vchiq.c     |  2 +-
>   fs/ceph/quota.c                                     |  2 +-
>   mm/kmemleak.c                                       |  4 ++--
>   net/bluetooth/mgmt.c                                |  2 +-
>   net/netfilter/nf_conntrack_proto_sctp.c             | 21 ++++++++-------------
>   samples/livepatch/livepatch-callbacks-busymod.c     |  2 +-
>   samples/livepatch/livepatch-shadow-fix1.c           |  2 +-
>   samples/livepatch/livepatch-shadow-mod.c            | 10 +++++-----
>   scripts/coccinelle/misc/secs_to_jiffies.cocci       | 21 +++++++++++++++++++++
>   sound/usb/line6/toneport.c                          |  2 +-
>   30 files changed, 79 insertions(+), 65 deletions(-)
> ---
> base-commit: 2d5404caa8c7bb5c4e0435f94b28834ae5456623
> change-id: 20241112-converge-secs-to-jiffies-d99d1016bd11
> 
> Best regards,


