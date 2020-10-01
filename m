Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB6327FFE3
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 15:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbgJANSb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Oct 2020 09:18:31 -0400
Received: from mail-vi1eur05on2099.outbound.protection.outlook.com ([40.107.21.99]:36961
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732018AbgJANSa (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 09:18:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Khau3mlqNSH9Vdh4JmJRj2mwgZ1Hbd/+7FOIj9qJOKVEpVWObs2aqab3hLhiqkYtc4ZGRlS+7dNyCTLePc1MCjz6kccA3M0Uy9Ob8lgkZWdwNzdJGH3h1uY/FEudZC0L7V+53xImBnlj0/hPo2sb+uCsYakwp5qKU2gKx3/f3VBm6LdZP7YPRQiPk4PN8Q5KDAE8nJt9dtiofGRcfewchxqusbyGUcYZKrAb9Or4qJSEACuCYkiy/1OpREGAQpxCdW236vCc2NA62CZaDFsnJKyfnmWCeCsM0gZjuxDmVjE8paCnZD+aWcsxEJQCYMx1H9BNxYNBq5zqQ36iUR+1dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlmVYrKE3Rr+6tw7VGp+Lx/GO9mzhYBp56YTLWJnF7s=;
 b=ktumRFPDDgrHhth/CHIuDvNokBHnVDaBiORD28kp2FDYGncbvT/XyKv12wCYPHmuBwEoWZ2wzSlSM2vzn8eTOse5IrlsWbFUY5CaSz0xwZKmgSguX3deaamxYDY2XDmzcEfFEdEgDeQstiwNmdk67E3ID8OU7jTlTQLMDNUKRRTF6v8q0k0SuJ2RzfoEXafCMPFPlrsM/nSSQbcC8QNGq4tD2XoGdjqJZgtxLdM4Bi1fNKk4ZGhc6qlP5/su2bc7QQdfD4YOfpjHGqDWKqO4uKO4jNcsVpdUR4x20Hn6X4V5Z+zqH7Cv2WVoYQQ8e0FDirep3JtiZIXl64KLRNTTmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZlmVYrKE3Rr+6tw7VGp+Lx/GO9mzhYBp56YTLWJnF7s=;
 b=uEHjtkSpR73Jan29wMbWaRxZXV5DeefXjH9SsKJi+d8EqyzKb/boz1P+zlBhYKvFBffz3slk+8Vr4XsMkkr2HJwdtg/mGsCzMonImstXeMvQGfTNWLngi4SyvrHYExUg5qsDCXVo0Eg2A0xI7IXcadMvvlW0/5n57SUBwHabvMg=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DBBPR08MB4507.eurprd08.prod.outlook.com (2603:10a6:10:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.35; Thu, 1 Oct
 2020 13:18:26 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183%6]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 13:18:26 +0000
Subject: Re: Patching kthread functions
To:     Nicolai Stange <nstange@suse.de>
Cc:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        pmladek@suse.com
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
 <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz> <87lfgqt8tt.fsf@suse.de>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <c2a4f36b-d974-2fa6-65d6-0d058a8773d6@virtuozzo.com>
Date:   Thu, 1 Oct 2020 16:18:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <87lfgqt8tt.fsf@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0146.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::15) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by AM0PR01CA0146.eurprd01.prod.exchangelabs.com (2603:10a6:208:aa::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34 via Frontend Transport; Thu, 1 Oct 2020 13:18:25 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aba8647b-b58f-4185-ea4e-08d8660c7abc
X-MS-TrafficTypeDiagnostic: DBBPR08MB4507:
X-Microsoft-Antispam-PRVS: <DBBPR08MB45071BE5F796A681E171B043D9300@DBBPR08MB4507.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhNH0sANA/oqvB6BP/O7fbNqqnld7CPFQKTPt6VuLVj37QDYnbWAXaNljcsItZBelQvEN8ukrq31Y30f8C8iouYDU52FSZ9lofQaR9ATZHtTAH1l5wHKzlI3/8tD/T3jvnqK/TnjT47RQHKWaI2LzCq5PBCicJ5aiJqgvS92hLSqazkV9krlHvn1K128+TbMBE6cFEbS6mlBYVaIZAR/NUirZW4X6W/9rsugZEt6XfuYnWZNuQMkgZpcUmg+cHbFZ5dYvZV0Kj5ufS9p6b+fUqh7IDuQGbX9t+lWdqqVGxtl1/sYWYTEW53QkspHIivtGmCA9xitq+FflKfKGorQYJ9MtOC8V50XxXK/ZOPJe4RCl0QAgfT7RtiqPSJ+QXB7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(2616005)(956004)(53546011)(4326008)(5660300002)(8676002)(8936002)(86362001)(31696002)(36756003)(31686004)(7116003)(52116002)(66946007)(16526019)(26005)(478600001)(83380400001)(186003)(6486002)(6916009)(16576012)(316002)(66556008)(3480700007)(66476007)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8EfTWOO0U4m9zkfjOrJZ/ks/Oi/5m3gAP89LOyjzsS5kjMVscft1ffyKebrLeiNMFW9do+Np453ovLG+oGV4BzafYb00i4eTyY2wmA5uBU9X29T8Hzid2gt5O/efctUFqbejGEI9WMVATTaYcEmFzLA01RzULopLpRnqtjzYzx5xNx0oX4SXhBtAiQO1e2D7ZfEIAOd8b+juKQ1rJcZLWemPLADnYvnuY0L00K6CUu/ux7EqN7Ovu0eSNJivqtbAHzdeeXVLNDoQ84qn3dWXdhu7J+Jwx9LIkz5VNyKY95Gm4OQPd8A/i//NGB69+BP7HXtgl0CbnfjnOFY9zy6k+KeUViKWsUjdt82TqTxW6fiuH3JJw1ZLdIbirAvr6hal4j7K+8Lk+63cSFQuzjEcPzJzAw1LoEzQWaXb9ZteQ3V3+Hwh+9ZaAfbNUyrzo6RJV13+jUSaFroJD8h1r8R0lZMjsvpOcSuhtJlFRFsd7VFtpbimhBtCCkCZeLWnkeNklPhYCFCQZcpTz4qmrGtDRVwyFO29N4q56ExIG2qlVw0/lnJNFKMGBmi1E2HetI0bT2TttGTB5IONj2LUWzEo/U4vcRMYgHQUewfZTNP9ZUCtJxE4GkSFvkVAxZdPcLi4XOklcZp3T99+Ca0xs2KwRw==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba8647b-b58f-4185-ea4e-08d8660c7abc
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 13:18:26.0945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+XJAuzpDKIjiSycq6Nf2q7d80wGe/texKYblSl9taKmo034ydc8PceFyXeMaady4XO7/8kPyr5FAhSYDIOfgVM+I79WoWt9xPGeCQZIn/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB4507
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 01.10.2020 15:43, Nicolai Stange wrote:
> Miroslav Benes <mbenes@suse.cz> writes:
> 
>> On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:
> 
>>> Is that so? Are there any workarounds?
>>
>> Petr, do you remember the crazy workarounds we talked about? My head is
>> empty now. And I am sure, Nicolai could come up with something.
> 
> There might be some clever tricks ycou could play, but that depends on
> the diff you want to turn into a livepatch. For example, sometimes it's
> possible to livepatch a callee and make it trick the unpatchable caller
> into the desired behaviour.

In this particular case, we needed to add a kind of lock/unlock pair 
around the request processing part of the function. Unfortunately, there 
is no suitable callee there.
> 
> However, in your case it might be easier to simply kill the running
> kthread and start it again, e.g. from a ->post_patch() callback. Note
> that KLP's callbacks are a bit subtle though, at a minimum you'd
> probably also want to implement ->pre_unpatch() to roll everything back
> and perhaps also disable (->replace) downgrades by means of the klp_state API.

Interesting.

Something like: block submitting of new requests to the thread, wait for 
the old requests to be processed, kill the thread, then start it again, 
unblock the requests.

Thanks for the idea!
> 
> You can find some good docs on callbacks and klp_state at
> Documentation/livepatch/.
> 
> Thanks,
> 
> Nicolai
> 

Evgenii
