Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5D84AF440
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 15:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbiBIOkT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 09:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235123AbiBIOkP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 09:40:15 -0500
X-Greylist: delayed 139 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Feb 2022 06:40:18 PST
Received: from p3plsmtpa07-09.prod.phx3.secureserver.net (p3plsmtpa07-09.prod.phx3.secureserver.net [173.201.192.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B4CC0613C9
        for <live-patching@vger.kernel.org>; Wed,  9 Feb 2022 06:40:18 -0800 (PST)
Received: from localhost ([82.17.115.212])
        by :SMTPAUTH: with ESMTPA
        id Ho6WnCu31VyEtHo6Yn8W0P; Wed, 09 Feb 2022 07:37:58 -0700
X-CMAE-Analysis: v=2.4 cv=YLFadTKx c=1 sm=1 tr=0 ts=6203d1c6
 a=9gipVNR6X1CoIeAWHwLoWw==:117 a=9gipVNR6X1CoIeAWHwLoWw==:17
 a=IkcTkHD0fZMA:10 a=9GtVR73LUgLZNubTt3gA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: atomlin@atomlin.com
Date:   Wed, 9 Feb 2022 14:37:56 +0000
From:   Aaron Tomlin <atomlin@atomlin.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Aaron Tomlin <atomlin@redhat.com>, mcgrof@kernel.org, cl@linux.com,
        pmladek@suse.com, akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, ghalat@redhat.com,
        allen.lkml@gmail.com, void@manifault.com, joe@perches.com
Subject: Re: [RFC PATCH v4 07/13] module: Move extra signature support out of
 core code
Message-ID: <20220209143756.53gw3ve46gaseqny@ava.usersys.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <20220130213214.1042497-8-atomlin@redhat.com>
 <alpine.LSU.2.21.2202091526260.32090@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2202091526260.32090@pobox.suse.cz>
X-CMAE-Envelope: MS4xfEeLTpDb717gdYrJ8fyJj8u9SbuxXa0FoEtTxchN+RygMn6avjFjDz9N44ZAJn4NF09emarra7B7k6YWEXFkXy4jjlZTCK/syx62dS3QtHH4AyFDi5zi
 m3KD+EFRaWERrm8o5Igt7fu78oTLn6xk5Zkj3FXHz7HaGODGGQmWOWyMzbvVW7CwHzQdzgbx8hp+U4MN7AGTV7GhbgRIdXswj96qgg+FNkEJ8dFxdk7yeyRu
 4lirWRDwcBzIXcYhHjCRR+4QuJNAkRWy724B7CCmb1PvjkcI2ynC43rJYjT2Jlm111JdHg7MTCoiEaehgYS6kJr8qQt+MIi577r4VcKn8CyJku6IErT8y51D
 bNiEZ9Pbo0WVSAWThlzavS0dLWzjuFnXayYFwGnTWibCR8UJzqjul4LVBlhDne2eQC0CjRWSH6Wwov1l91S2qbCAWg5znBfTaHGdI3luseoeHM+YR18mEAjw
 Qqvhk7Ynq/E2L0TzbaXhNXabcgiRv9ZGXVP37Rp/eUx3j2L8jHv1DZcbEjSWtBSN9skxXBTh1U2IA4vof5J0BzZAOD+eAO+uhDAul0YH8Cw0ZfQaRAOD2qML
 LS4=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-09 15:28 +0100, Miroslav Benes wrote:
> Please, drop these extern modifiers in front of function declarations. 
> They are unnecessary. It applies to different patches of the set as well.

Agreed - this was suggested previously.
The next iteration should be published soon. Just waiting on 0-day.

> > +#ifdef CONFIG_MODULE_SIG
> > +extern int module_sig_check(struct load_info *info, int flags);
> > +#else /* !CONFIG_MODULE_SIG */
> > +static int module_sig_check(struct load_info *info, int flags)
> > +{
> > +	return 0;
> > +}
> 
> I think it should be 
> static inline int module_sig_check(struct load_info *info, int flags)

Yes, indeed it should. Thanks for the feedback.


Kind regards,

-- 
Aaron Tomlin
