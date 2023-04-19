Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04BF6E82A8
	for <lists+live-patching@lfdr.de>; Wed, 19 Apr 2023 22:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDSU2L (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Apr 2023 16:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjDSU2I (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Apr 2023 16:28:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8885BBF;
        Wed, 19 Apr 2023 13:28:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DA4F41FD9B;
        Wed, 19 Apr 2023 20:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1681936081; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDVkBZEcchpCDnJPndKZSVaqY93ccvwAY/GoNfUegkw=;
        b=uf1vRGDDAONFBHtTTxCRWGk9Sw7dj2G9JJtpXG9AEo6IlMS1IyD9gtUC4yJpg032MAW/pI
        bOt7tKd9P+c1xsT2WOu39k0TT0aM+JrTccAuUJjqPfTkdp2QIr7hMYk0yuoo7XMvpZcKw3
        RS2y8oDXbv9JLv+Ej6zLUKEZHjw9zeQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1681936081;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZDVkBZEcchpCDnJPndKZSVaqY93ccvwAY/GoNfUegkw=;
        b=WnZRyMrpsitCwSbACOb895+oc1UZpWuzRZJVe0UMbQ4RCDasVEr76YOKe8i6Re9ZZikXmN
        BU5dS+IuDDSAN8Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5B3FB13580;
        Wed, 19 Apr 2023 20:28:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Dy6DCNFOQGS7JAAAMHmgww
        (envelope-from <mpdesouza@suse.com>); Wed, 19 Apr 2023 20:28:01 +0000
Date:   Wed, 19 Apr 2023 17:27:58 -0300
From:   Marcos Paulo de Souza <mpdesouza@suse.de>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v7 00/10] livepatch: klp-convert tool
Message-ID: <gcom3bvjxyyqnyewm2qcwixptdyqie32oouvu73plh3ure3xrs@76qakvukdfxf>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306140824.3858543-1-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> Testing
> -------
> 
> The patchset selftests build and execute on x86_64, s390x, and ppc64le
> for both default config (with added livepatch dependencies) and a larger
> RHEL-9-ish config.
> 
> Using the Intel's Linux Kernel Performance tests's make.cross,
> klp-convert builds and processes livepatch .ko's for x86_64 ppc64le
> ppc32 s390 arm64 arches.
> 

So I tested using real x86 livepatches, and it worked as expected. The test was
done by taking the livepatches, removing all externalized variables (those that
we need to call kallsyms_lookup), and compiling as usual and using
klp-convert to create the necessary relocation entries.

I'll keep testing with more livepatches for now on, and let you know if I find
any issue.
