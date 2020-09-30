Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CBE27EDAF
	for <lists+live-patching@lfdr.de>; Wed, 30 Sep 2020 17:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgI3Por (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Sep 2020 11:44:47 -0400
Received: from mail-eopbgr00128.outbound.protection.outlook.com ([40.107.0.128]:63991
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725372AbgI3Poq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Sep 2020 11:44:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftTq5AlFOjnen/xW1uem0ULz5m3a4BGdjXxpMxOLNx5u6gjyMYDPTBnqJfA3CSfcwYFciAdjmTZVCtX88k7LFQegl9yqmd/0ZGCiGPZ/EUszzHAMGqee+BB3NeW7hEB1fVWRp8fMEzChc86/sNw7Na0KrYd+/sUS/bWJxpfXySJbXyDgfvCJDEEQSG0k2i6gin9jq7jVRsHzSYPDNbuGIqNT2YLlTO+fnwEFrza/zD/ThuZb3cPpAKODtVpJet5kRU1VTNLpw2/sZeNkKhZZbI5aWYAsjteiy8VzVPmBkhWIEV8jekTTSvFGp/rZxMKrWldjYmO8M/WSyDU/2ziXvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FGzuetHfMaTJtNP9oqSO6YvNirkF8HRSgJuofEtKMM=;
 b=SbvzFjh7iIBtzpRVMGmkcnAyWCDVPF1Po5H0wq94+zUvrB5B+OR/wbF9w71X0xse9Li6bcaDZdBKcdb3liUX4Bm5VbDeFMe6UE+VnraX209e/aaR3JzxN0ESMLyZeDzyyl7WyUfMfXmtbgxcTTeRjMT1CYluW6LzxpM/08a3mNV8vopDSIb41hMAD2gtXX3VgEL6cz0MVE+Y8XzjDRtmOzM1Lj0aUNaD4/FXzwMNTfKylsmfAQ4UWcmpPgbgPx03+KbXqKjFZ2JNSuj/lG4mAKmLgicsPyFfFFsYDv5iYo/rMuLoWxUn6jmdqryDT8BOXASCeUj7PAaTNWFcUvSb8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FGzuetHfMaTJtNP9oqSO6YvNirkF8HRSgJuofEtKMM=;
 b=TAQN6AMjpu7p4wadwlWCypkJB3eBard+mdKGiMg70hFbjqgipDVyIbOiee0nVc06pbMAlfZGyzz5xsoxsrz5sPqYcrxv5y8yCebiWAtqAz2IOdDfNbVv2F2h5cSAtPl84QWEUsns5kDrxqVsUnF2yI8/ZAeptyxqeRb133yGxMM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB6PR0802MB2536.eurprd08.prod.outlook.com (2603:10a6:4:a2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Wed, 30 Sep
 2020 15:44:43 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183%6]) with mapi id 15.20.3412.029; Wed, 30 Sep 2020
 15:44:43 +0000
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Subject: Patching kthread functions
To:     live-patching@vger.kernel.org
Message-ID: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
Date:   Wed, 30 Sep 2020 18:44:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28)
 To DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by FRYP281CA0018.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.14 via Frontend Transport; Wed, 30 Sep 2020 15:44:42 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80659e6b-069b-47be-02d3-08d86557bffc
X-MS-TrafficTypeDiagnostic: DB6PR0802MB2536:
X-Microsoft-Antispam-PRVS: <DB6PR0802MB2536178449F4FCEB4BDB1EA8D9330@DB6PR0802MB2536.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qHKjeEvnfgnPhn6Oy7nwABHnItpZUHWDvNXYsg7e0/6d8BkCFUHT4Il1++4In+5ISoZj9VbPIDv+zIsrELoYJu3m6gTtttzO+N3WBIqF6obadV43DSZb6b0ZHC3GnMcVTDx568u1AO0Xt0Qyg2PfkKCt3b81O5LJ5lqM3ZsOBcLpN1QCHzfWdw0n47c4dtiJ1H2qBUnxTgR9LSv/+GTEpJcwueef5CIZDw6cfi87beuZuH5esvBNyxxE21903TYA/6QhedHo3CGUTjOMV8JZ0IwwvnXN5Rd4wlgK008IvY++ZKj44Pu2IJ6BEvPNWveUMUyLscwuPjWxRzCkfHfaYUmdBV9qclBHcDfcd8xoDQg3RDUqcTggl8hBC9SSiadR+jgnKR1r6aEY8Xr7BY/tuKr/E2dpjgE+wnTLPhlcsRbUvmVRzawcn0GLdlVWWm3bLPGg/buSVgKiHMsK8hTC4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(39830400003)(396003)(6916009)(966005)(66556008)(2906002)(66476007)(66946007)(8676002)(3480700007)(8936002)(316002)(16576012)(478600001)(6486002)(36756003)(16526019)(31696002)(83080400001)(86362001)(956004)(2616005)(5660300002)(52116002)(186003)(83380400001)(31686004)(7116003)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 21CeznPk+VqHjkTkUpUrW6XDKrfJSU+okn6S8uEGin00xY0HOosL5kL1nuft75G0xQ53d4ANh1EqK6aDQzj8ggDpAlRwO9AL8ceUTPTuemhjMHrH3Jl5U0trcsMlR1bZIvMpy521xrL3oGiOijC6F69ug2WiRBMYk5tXKO6HHgvsRoaCn0YyFjMHRT4Ib6YsHkTiMlpSCAj7mb1UU8yrRi4rdHdMMbbGw46wQtzpt+ITv7q2b5dCHWoBl5V2YlomBUUkC1U7K5wRqpd6W+ZCU1k4LjPvF676ZXJviHV11oaxHVn2ewCe5kNwo2Caqw2r/UkxGzbJIDPqZpfZgUxkNXg4RthfZrLcjLPQapohZ003P6FVbSmSLsX9YFkFFdH2M7SECZma70NCQYkovlfERAMqjpeXQwe2QYM7XErjDXsm0rioSqXBn4C7Hswxc0JyvIvh31Ut60WnJIB4eN0De5bOCewkWpPQLJaQbjueFChIOAz4kRnH3P8gke3iLLRlFMK+blVjlnHREDyU+LrRGdHdV1IAyM0fADRGbLhcwULioK4FEoSLhXGD7Pu07uuEWRrSAEdrMzC1fjtaTBpeU3E57mDFxtA/8nMVEillnMlUxAxMfk4cKUKkfYdXwhZpu9sOTFbUDyexrpHuHdMwiw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80659e6b-069b-47be-02d3-08d86557bffc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2020 15:44:43.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9JAHOUo1tUuTts7Bhke/KkydiC4M7M4ZE41Q1l39hR+O8abHPZtw4owMSb0Su2Tp2Is4exi1l3vwYUHThT+AK6zutX4mvLAku9yXTzT2ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2536
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

I wonder, can livepatch from the current mainline kernel patch the main 
functions of kthreads, which are running or sleeping constantly? Are 
there any best practices here?

I mean, suppose we have a function which runs in a kthread (passed to 
kthread_create()) and is organized like this:

while (!kthread_should_stop()) {
   ...
   DEFINE_WAIT(_wait);
   for (;;) {
     prepare_to_wait(waitq, &_wait, TASK_INTERRUPTIBLE);
     if (we_have_requests_to_process || kthread_should_stop())
       break;
     schedule();
   }
   finish_wait(waitq, &_wait);
   ...
   if (we_have_requests_to_process)
     process_one_request();
   ...
}

(The question appeared when I was looking at the following code: 
https://src.openvz.org/projects/OVZ/repos/vzkernel/browse/drivers/block/ploop/io_kaio.c?at=refs%2Ftags%2Frh7-3.10.0-1127.8.2.vz7.151.14#478)

The kthread is always running and never exits the kernel.

I could rewrite the function to add klp_update_patch_state() somewhere, 
but would it help?

No locks are held right before and after "schedule()", and the thread is 
not processing any requests at that point. But even if I place 
klp_update_patch_state(), say, just before schedule(), it would just 
switch task->patch_state for that kthread. The old function will 
continue running, right?

Looks like we can only switch to the patched code of the function at the 
beginning, via Ftrace hook. So, if the function is constantly running or 
sleeping, it seems, it cannot be live-patched. Is that so? Are there any 
workarounds?

Thanks in advance.

Regards,
Evgenii
