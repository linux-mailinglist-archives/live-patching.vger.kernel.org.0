Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDCFD4B71AE
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 17:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239586AbiBOPGL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 10:06:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239560AbiBOPGL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 10:06:11 -0500
Received: from p3plsmtpa09-10.prod.phx3.secureserver.net (p3plsmtpa09-10.prod.phx3.secureserver.net [173.201.193.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BF9108571
        for <live-patching@vger.kernel.org>; Tue, 15 Feb 2022 07:06:00 -0800 (PST)
Received: from localhost ([82.17.115.212])
        by :SMTPAUTH: with ESMTPA
        id JzOvneUB7ApSlJzOxnv8kp; Tue, 15 Feb 2022 08:05:59 -0700
X-CMAE-Analysis: v=2.4 cv=G8PZr/o5 c=1 sm=1 tr=0 ts=620bc157
 a=9gipVNR6X1CoIeAWHwLoWw==:117 a=9gipVNR6X1CoIeAWHwLoWw==:17
 a=IkcTkHD0fZMA:10 a=eRuHl9Be23FFiiB-UZwA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: atomlin@atomlin.com
Date:   Tue, 15 Feb 2022 15:05:57 +0000
From:   Aaron Tomlin <atomlin@atomlin.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Aaron Tomlin <atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate
 file
Message-ID: <20220215150557.g7mvx47ibhjgweyo@ava.usersys.com>
References: <20220209171118.3269581-1-atomlin@redhat.com>
 <20220209171118.3269581-3-atomlin@redhat.com>
 <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu>
 <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
 <d3d87e3e-e13f-252a-1c06-f18a78af5d98@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d3d87e3e-e13f-252a-1c06-f18a78af5d98@csgroup.eu>
X-CMAE-Envelope: MS4xfE6u2n9DvFiGsYMeR3knNtd1Uva+OFrVy9oEyo66zu27ZGI/MXq9RjqzQsM7JLBsAGQrHziUfDdZ7PdUHEDucW7KYBpPGXdMA/s8RfiJnGF60yp5OQYQ
 34/DADYiivZZnSXdDmDZacjYodnY31fPUWCaK3qKjfCC/vsG0fCkkBDofkzoDMhdkqppdsgwwMPmR/Bdtyad0GIOiI/dFI/FiLsnQqQmirhgLcu931KyiKwj
 SlvzCVK19hmmJJQpNKfjg5Yr1yN70RRQZlxrhJp4L8kCi981iCR4BD8dPGNMonpNkobC83Ao7/y9NrV23L/CfXW7lAlCvrM3CfFmBy03x8hxADWskgR4dmje
 XQMt+oVaFTySOqjuoLn1TEJRvtiUiD9wKcknPxlG1e8SRkMLOfcY/Iv31YpgV0RF6tR/bZYv3/WnRDs+Mp+3atcCwI+LrTQQahfVPVTXmWiB1ctlrMUi0M9r
 /k9O/7j3TceeRL9hUZkWQiPtXognSDh4GSoqPybHOm3CLj/HtrnRsKG7HoR4xpx6mEknNrOTsvJECi1pWr2/Oeznfld1mJLvjR+r7KMrNtBFKzWpwZGpr+9Z
 a8LD96SgYe1oEx0N3cWMiQiZgdp5vvnLrdhbDs6uKS/qKsN5jytzrRXnWi/Da74X2T/yKdrhm8GJ1GR4wejhOSAKOpTIFaVDVYO1UZ49HJcbyg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2022-02-13 18:29 +0000, Christophe Leroy wrote:
> I'm not sure you can do that.
> 
>  From commit 8c8ef42aee8f ("module: include other structures in module 
> version check") I understand that module_layout is there for some signature.

Hi Christophe,

I see. In which case, if I understand correctly, we'd have to ignore the
report from Sparse. I will add a comment to hopefully suggest against
removal.


Kind regards,

-- 
Aaron Tomlin
