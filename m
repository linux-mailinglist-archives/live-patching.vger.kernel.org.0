Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AC76F4DAE
	for <lists+live-patching@lfdr.de>; Wed,  3 May 2023 01:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjEBXiK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 May 2023 19:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjEBXiJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 May 2023 19:38:09 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7396E3594;
        Tue,  2 May 2023 16:38:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 11EB51FD8E;
        Tue,  2 May 2023 23:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683070686; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FT4wWIFE9IpebB/66dG6JpLGUoIaaQlGJ8KBJQi7+T0=;
        b=l5k/TelchZJdm/qSeeM4RDGq1WWPUF/0XIRJYvKp0I/akn1Xd8EHAJ2Wh2SvcHTB9ZZOF4
        8yrjroNWQ7LV87PuOd/r2wVGA6pFr1feUUymzy2TjayxyTQeoH4riu7eEEBtqvM8ycVzzt
        +SwTyS61Lp8vhgs2yJntQwhcr42RX7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683070686;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FT4wWIFE9IpebB/66dG6JpLGUoIaaQlGJ8KBJQi7+T0=;
        b=3jhnf0pMgzOGgpWWjzF7HUgqHr+xPS0oBIme40Mvp/M1kB/3bUkrjbcVKwzZqzZE9Dop7u
        RVF/aYTpP6/jfHDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69AB7139C3;
        Tue,  2 May 2023 23:38:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1iHWBt2eUWRjfwAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Tue, 02 May 2023 23:38:05 +0000
Date:   Tue, 2 May 2023 20:38:01 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Lukas Hruska <lhruska@suse.cz>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <dlivegt4sjm632m3sete73me3i2rceojfo4q4hji5ubvdcn2ly@f3tx6y5kqmkc>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230314202356.kal22jracaw5442y@daedalus>
 <ZBTNvEPrCcRj3F1C@redhat.com>
 <20230317232010.7uq6tt4ty35eo5hm@treble>
 <873556ag24.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <873556ag24.fsf@suse.de>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 11, 2023 at 12:06:43PM +0200, Nicolai Stange wrote:
> Josh Poimboeuf <jpoimboe@kernel.org> writes:
> 
> > On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
> >> Have you tried retrofitting klp-convert into any real-world livepatch?
> >> I'm curious as to your observations on the overall experience, or
> >> thoughts on the sympos annotation style noted above.
> >
> > On a related note, the patch creation process (of which klp-convert
> > would be part of) needs to be documented.
> >
> > If I remember correctly, the proper safe usage of klp-convert requires a
> > kernel built with -flive-patching, plus some scripting and/or manual
> > processes.
> 
> Not always, I think: -flive-patching or IPA optimizations in general
> aren't a concern in the context of data symbols. From a quick glance, it
> seems like the selftests introduced as part of this patchset are
> all restricted to this usecase.

<snip>

> What do you think, does it make sense to eventually have such a bare
> minimum klp-convert merged in-tree, independently of the ongoing
> discussion around the livepatch preparation processes, respectively (the
> lack of) documentation around it? If yes, Lukas, now on CC, is
> interested in this topic and would be willing to help out in any form
> desired: either by contributing to Joe's work here or, if deemed more
> feasible, to start out completely new from scratch -- dependent on your
> opinion on the proposed, more minimal approach as well as on Joe's plans
> around klp-convert.
> 
> Looking forward to hearing your feedback!

So guys, any feedback? Ping :)

> 
> Thanks,
> 
> Nicolai
> 
> (*) We've been experimenting with building the relocation records
>     manually by various means, e.g. with GNU as' .reloc directive as an
>     example, but this all turned out impractical for various
>     reasons. Most noteworthy, because the records' offsets wouldn't get
>     adjusted properly when linking AFAIR.
> 
> (**) by some other means than directly with kpatch-build
> 
> -- 
> SUSE Software Solutions Germany GmbH, Frankenstraße 146, 90461 Nürnberg, Germany
> GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
> (HRB 36809, AG Nürnberg)
