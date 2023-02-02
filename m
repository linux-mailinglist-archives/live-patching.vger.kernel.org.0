Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9442E688757
	for <lists+live-patching@lfdr.de>; Thu,  2 Feb 2023 20:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjBBTHk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 Feb 2023 14:07:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjBBTHj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 Feb 2023 14:07:39 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46A823DA9;
        Thu,  2 Feb 2023 11:07:38 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5902233777;
        Thu,  2 Feb 2023 19:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675364857; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dg041K7tIoThUfKRkIjYDBZKfn1eYN5bhtoIxmkL4x4=;
        b=uNbPFEPuqFYLQ0NJi/zsBYnV6v1nxaZJhwL35M1kVeA/bZvjR+ReFfrm+g29eqa49FMRVq
        ONfEcsuAehm0ihjQKQ/AdUq/GytuMYh6PKuuztEGfptnx4Hx0DhqqgDqg1fb1X5bLP259N
        UHqWxQlAe2EbITKKlfprVjpX20vyJoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675364857;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Dg041K7tIoThUfKRkIjYDBZKfn1eYN5bhtoIxmkL4x4=;
        b=xcGV8hO84cihZqBUc7Z5TXaqDxMCXtUtD7/MAR4PQCFcM6kxYipTZQmANo3bpKQTLPamkV
        OOe7+HDN8vWWB8Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C0A8D139D0;
        Thu,  2 Feb 2023 19:07:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /VNwIfcJ3GNZTgAAMHmgww
        (envelope-from <mpdesouza@suse.de>); Thu, 02 Feb 2023 19:07:35 +0000
Date:   Thu, 2 Feb 2023 16:07:32 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH] module.h: Document klp_modinfo struct members
Message-ID: <20230202190732.tyqn2wwrvy3ot56f@daedalus>
References: <20230202182950.10471-1-mpdesouza@suse.com>
 <Y9wIw3f8IBOs4Ad6@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9wIw3f8IBOs4Ad6@bombadil.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Feb 02, 2023 at 11:02:27AM -0800, Luis Chamberlain wrote:
> On Thu, Feb 02, 2023 at 03:29:50PM -0300, Marcos Paulo de Souza wrote:
> > The struct members description can be found on
> > Documentation/livepatch/module-elf-format.rst, but for a developer it's
> > easier to search for such information looking at the struct definition.
> > 
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> Why not just embrace kdoc and then refer to it in the rst files?

Seems to be a very good idea Luis. I'll try to find some examples in our Docs
how this is done.

Thanks

> 
>   Luis
