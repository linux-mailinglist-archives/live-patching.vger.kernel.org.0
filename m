Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967104B2940
	for <lists+live-patching@lfdr.de>; Fri, 11 Feb 2022 16:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbiBKPmL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 11 Feb 2022 10:42:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiBKPmK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 11 Feb 2022 10:42:10 -0500
Received: from p3plsmtpa06-05.prod.phx3.secureserver.net (p3plsmtpa06-05.prod.phx3.secureserver.net [173.201.192.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A43D47
        for <live-patching@vger.kernel.org>; Fri, 11 Feb 2022 07:42:07 -0800 (PST)
Received: from localhost ([82.17.115.212])
        by :SMTPAUTH: with ESMTPA
        id IY3hn6xiQB0VlIY3inf1ER; Fri, 11 Feb 2022 08:42:06 -0700
X-CMAE-Analysis: v=2.4 cv=JvY0EO0C c=1 sm=1 tr=0 ts=620683ce
 a=9gipVNR6X1CoIeAWHwLoWw==:117 a=9gipVNR6X1CoIeAWHwLoWw==:17
 a=IkcTkHD0fZMA:10 a=dVhMRCx2zczmgBi7b7cA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: atomlin@atomlin.com
Date:   Fri, 11 Feb 2022 15:42:04 +0000
From:   Aaron Tomlin <atomlin@atomlin.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "20220209170358.3266629-1-atomlin@redhat.com" 
        <20220209170358.3266629-1-atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
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
Subject: Re: [PATCH v5 08/13] module: Move kmemleak support to a separate file
Message-ID: <20220211154204.2x66sauy3o7albbe@ava.usersys.com>
References: <20220209170814.3268487-1-atomlin@redhat.com>
 <20220209170814.3268487-2-atomlin@redhat.com>
 <2bee9eb2-d59f-a5cd-d89a-b818d94b74af@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2bee9eb2-d59f-a5cd-d89a-b818d94b74af@csgroup.eu>
X-CMAE-Envelope: MS4xfHu+JTidec1ZvQoeAPFxW0bRE+TKm6P15qJNOqu0xi7lnglPa8eV8LDpEdnhMS2WrErAGVyxe7OWbRXmSJBFi8fy112D4snAvV8CSygQdCmZcF8wyVOX
 H8R1o1eVc6jQ5WvOjsu5TD7In+mfA0F9ZP85yb2QZOk+Wwpdbu5MbWrOH4L0//oFX0pa1Ip42Sd7L+gcJ+Bh4ViCIAcCJeXMweblY6vSvliSwDSN+Qmfd7GN
 TX3+F3mpSbmee4kEuqEP+fb5v5k0qdX1Aaqs1+vJ7K/lTGcZbsaoSHvRDb4v0NRwT7jgYTf8R03tgOVa/3OBzzGGG9Fi95iXsyYMkgaKKxFDZvhUmdA4Y/a3
 4jOOGdLuLSNMJPLONR5eHZCInoZUMDpV/HD/17EwdYWwMiyvSmwbxZ2TF+O6dNwoxm9VXrBSHikgSV7HTVko8icLVZtijuuZhC3FVAs7yDtYNNbnr3U8ZX6Y
 7Eqa3WGVHlC3mqrVI0fKMF+33PEN+pqN6mgDIfiUDHcqTPWs9jCWZVzMBFk13VhNkd50LxYxtipxBhOEamdmg7xVyJesGqvlI2WSUziee+WpvwtBl27EbyI9
 XdamloG/ABKJwsk0V8yf8uMdPxr/S8qb+kXf1nnZqf2OT0pidFvJhWozsFHvosQaHGKQN7YKgGQ9YpYiu0+3Uc+LL3VIF63Y3QH9L2EIhEE8d3Kz1jFiatAK
 9pIOIuZCwHF2bjxgkGIiut4LKhW3CwEKBnGiYjqGswNlWcXO/NOH6Q==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 13:07 +0000, Christophe Leroy wrote:
> CHECK: Alignment should match open parenthesis
> #48: FILE: kernel/module/debug_kmemleak.c:13:
> +void kmemleak_load_module(const struct module *mod,
> +				 const struct load_info *info)

Ok.

> > +static inline void __maybe_unused kmemleak_load_module(const struct module *mod,
> > +						       const struct load_info *info) { }
> 
> Remove __maybe_unused, not needed for a 'static inline' in the .h

Agreed.

Thanks for your feedback Christophe.


Kind regards,

-- 
Aaron Tomlin
