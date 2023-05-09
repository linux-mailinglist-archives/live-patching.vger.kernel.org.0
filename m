Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1406FCF8F
	for <lists+live-patching@lfdr.de>; Tue,  9 May 2023 22:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjEIUez (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 9 May 2023 16:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjEIUey (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 9 May 2023 16:34:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1239E10FE;
        Tue,  9 May 2023 13:34:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5E63D1F749;
        Tue,  9 May 2023 20:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683664491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3D8zA2tmAmIa323+7ZF/XLPZJO7JogZ7ToR1HtZFDM=;
        b=0I8DhwtC7cuSTVHblvvoG/OReiK2L4AFZRelRMvJ2uoQMIB6Y6qLnvBiA1jityK88b9W7/
        h7xhozNFf4FOIfajQRz+QVXKWApqTdPwVPfg9A/5nxCu3yZuT9rU6qWMwOu7Tfz/qn+T56
        4dC1H/0CFpmohCdjxv2KWKGuzuB2eZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683664491;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K3D8zA2tmAmIa323+7ZF/XLPZJO7JogZ7ToR1HtZFDM=;
        b=xmiFJQDxWV48mWyA1idnEfNYHFeEYTbFAwbSkQBSpdzajM01VvE6m4M5IVdWqdg3Ovmy/0
        5vbHjx/sDNnVmlBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D55E5139B3;
        Tue,  9 May 2023 20:34:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Ai+bJmquWmQjRgAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Tue, 09 May 2023 20:34:50 +0000
Date:   Tue, 9 May 2023 17:34:48 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Nicolai Stange <nstange@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>,
        Lukas Hruska <lhruska@suse.cz>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <coxl6y2ivnp6tqxclpm54m4fpbf3ansil3abftbj4nv76vuheq@sxvagra4almd>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
 <20230314202356.kal22jracaw5442y@daedalus>
 <ZBTNvEPrCcRj3F1C@redhat.com>
 <20230317232010.7uq6tt4ty35eo5hm@treble>
 <873556ag24.fsf@suse.de>
 <e41b041a-6a9e-210a-bf09-14db2b637e79@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e41b041a-6a9e-210a-bf09-14db2b637e79@redhat.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 03, 2023 at 03:54:47PM -0400, Joe Lawrence wrote:
> On 4/11/23 06:06, Nicolai Stange wrote:
> > Josh Poimboeuf <jpoimboe@kernel.org> writes:
> > 
> >> On Fri, Mar 17, 2023 at 04:29:48PM -0400, Joe Lawrence wrote:
> >>> Have you tried retrofitting klp-convert into any real-world livepatch?
> >>> I'm curious as to your observations on the overall experience, or
> >>> thoughts on the sympos annotation style noted above.
> >>
> >> On a related note, the patch creation process (of which klp-convert
> >> would be part of) needs to be documented.
> >>
> >> If I remember correctly, the proper safe usage of klp-convert requires a
> >> kernel built with -flive-patching, plus some scripting and/or manual
> >> processes.
> > 
> > Not always, I think: -flive-patching or IPA optimizations in general
> > aren't a concern in the context of data symbols. From a quick glance, it
> > seems like the selftests introduced as part of this patchset are
> > all restricted to this usecase.
> > 
> 
> IIRC there is nothing currently stopping klp-convert from converting
> function symbol relocations.  That may be dangerous when taking
> optimizations like sibling functions (and their sharing of stack) into
> consideration.  This is about the point I stopped to turn and see what
> the real use cases may be.
> 
> >> If nobody knows how to safely use it then there wouldn't be much value
> >> in merging it.
> > 
> > I tend to agree, but would put it a bit differently: the current
> > implementation of klp-convert features quite some convenience logic,
> > which, until the question of a documented livepatch preparation process
> > has been settled, is not known yet to ever be of any use.
> > 
> 
> Good observation and perhaps something that Marcos could elaborate on
> (pros and cons of klp-convert in his experiments).
> 

In my tests, I took the exact code generated by klp-ccp, and adapted it to not
rely on kallsyms anymore, removing the symbol lookups. For data symbols, I
changed it to be a extern variable instead of a pointer to it. For the function
symbols, also removed the pointer lookup, and left only the function prototype,
and it worked as expected.

I was quite surprised that it worked quite well. But I agree with
Nicolai that the tool itself could be shrunk into a smaller version. In our
usage, klp-ccp knows all unexported functions and to which modules they belong,
as it's currently used for the symbol lookup. I believe that kpatch-build also
has similar information so all the symbols.klp and other Kbuild machinery could be
avoided, making the tool responsible to only generate the klp relocations based
on the undefined symbols, just as proposed by Nicolai.
