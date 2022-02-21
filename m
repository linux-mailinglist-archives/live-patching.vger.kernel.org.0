Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDA574BDBBF
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357230AbiBUMCc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 07:02:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357235AbiBUMCb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 07:02:31 -0500
Received: from p3plsmtpa09-01.prod.phx3.secureserver.net (p3plsmtpa09-01.prod.phx3.secureserver.net [173.201.193.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6E2BC9E
        for <live-patching@vger.kernel.org>; Mon, 21 Feb 2022 04:02:04 -0800 (PST)
Received: from localhost ([82.17.115.212])
        by :SMTPAUTH: with ESMTPA
        id M7OEn8BQ8VclJM7OFnYqq5; Mon, 21 Feb 2022 05:02:04 -0700
X-CMAE-Analysis: v=2.4 cv=K4LnowaI c=1 sm=1 tr=0 ts=62137f3c
 a=9gipVNR6X1CoIeAWHwLoWw==:117 a=9gipVNR6X1CoIeAWHwLoWw==:17
 a=IkcTkHD0fZMA:10 a=20KFwNOVAAAA:8 a=_I3s7B_8TjLGI8JKYzcA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: atomlin@atomlin.com
Date:   Mon, 21 Feb 2022 12:02:02 +0000
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
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate
 file
Message-ID: <20220221120202.rsj3wqz2ycd2tgcm@ava.usersys.com>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-10-atomlin@redhat.com>
 <40f31a7b-2d06-8316-1a88-128ba72518a5@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40f31a7b-2d06-8316-1a88-128ba72518a5@csgroup.eu>
X-CMAE-Envelope: MS4xfE57LHryfOCe9ugcfLRAXRce7zu0hGZXbsl4qZzo20gLnp5ecJHkCEp7nzcsG6IgDlPOV44dQdr6WNEnpRlGmoPtzLuhHw9jF813OiXpRRy5ZOjiP/16
 lLrjxKwz/Mi+kvNMGqYh6DjB4BLH75z4DLaLN1y0urhCdue76NLrysu30FgXCySO6Dz7CvG8XPIncQCOL7hkIti3iDKOLlnnsqKxB71D7TL4sYgnK5yXhdz0
 xuXMQaM4E2uavG3HJbn4fpbs9N0l0EouuXBq+yQgO4KLjZGjTxVHw5hgXYMc+tuXVm/0p/9WY6ToPiselsbbjvx/gD52yLL9rPB2DIhclaA9i4WCl1Y8JhXJ
 JcvO3Jzy2mSkMheiw7k853sXZjmHxKzQkPVer7VA2afXFf4Vknie1z2AsEeRw6amJ9x0hZXEEMWT98WcXBCzHc9S2Di9uFqy5lCp7uy4wPok8xDRAmjpvfPa
 H2s7DkmYiMY8QDQ+V/lmCCoQxy5AiPnflSMJee9a0a89JLEmc7gIWMwk/TFd2op6pZu1xEFvALP/9hzHRhtkDlk5sjA0lzUTYykwD4ddLDPK4mQR4aH3EXWe
 SLHFIGnAHe7Rwh95xJhCPZZoDMXQW6fg+9VlvMVGw+egRdLSszdT2BmUWqRKyQiD/GJop7J41gkDVPUj8tVNLZem
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,WEIRD_PORT autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-02-21 10:49 +0000, Christophe Leroy wrote:
> Le 18/02/2022 à 22:25, Aaron Tomlin a écrit :
> > No functional change.
> > 
> > This patch migrates kallsyms code out of core module
> > code kernel/module/kallsyms.c
> > 
> > Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> > ---
> >   kernel/module/Makefile   |   1 +
> >   kernel/module/internal.h |  32 +++
> >   kernel/module/kallsyms.c | 502 ++++++++++++++++++++++++++++++++++++
> >   kernel/module/main.c     | 531 +--------------------------------------
> >   4 files changed, 541 insertions(+), 525 deletions(-)
> >   create mode 100644 kernel/module/kallsyms.c
> > 
> 
>    CC      kernel/module/main.o
> kernel/module/main.c: In function 'load_module':
> kernel/module/main.c:3379:9: error: implicit declaration of function 
> 'init_build_id' [-Werror=implicit-function-declaration]
>   3379 |         init_build_id(mod, info);
>        |         ^~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:288 : kernel/module/main.o] Erreur 1

Christophe,

I assume both Kconfig option CONFIG_KALLSYMS and CONFIG_STACKTRACE_BUILD_ID
was not enabled. I'll address this.

Thanks,

-- 
Aaron Tomlin
