Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C18467D772
	for <lists+live-patching@lfdr.de>; Thu, 26 Jan 2023 22:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232752AbjAZVMk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 26 Jan 2023 16:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231856AbjAZVMj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 26 Jan 2023 16:12:39 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73BEE053
        for <live-patching@vger.kernel.org>; Thu, 26 Jan 2023 13:12:38 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id m8so1328754ili.7
        for <live-patching@vger.kernel.org>; Thu, 26 Jan 2023 13:12:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mQPwRIBKhjb6JhTfp5iOA/66mO6S7MMMqq8824Tk2b0=;
        b=HNU9PynKvAx2Imqc0jgm2uqETw6F54OUO0SSiTEIJebfso5A4bn9aZ+5oCUUMn25X/
         V0yHOqUa9bF4IC/tI0Zb/zxgNzutu2sU7/g4sOQf4FfXqwMNszdlOBr42qng17jrigHc
         e2rNCMsmuW+kgB1D2mg74e9vNEYTG9vqW5aAE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQPwRIBKhjb6JhTfp5iOA/66mO6S7MMMqq8824Tk2b0=;
        b=1T5fzqGuHqY2ekmzivEx8px/9jG99vETSKCtsaqqcw+qJHazCpPJOuG2LtbUphvjRe
         v+yxUAmyViteVN04ydrswRTRIYiliu6cygDoccdTN2u8cjMxdjr0VxFHLZT7sGzxGXbV
         HCkrPgp9dbrjMdVuwkDPGNS3cTgdChBATxgU6WuPZ0CnrM8e97o5QAsMjqtWzHM3fMaD
         63ozhEdvVHj0IntXs2ocb9hdtAg4hU1qnmTxE8FqdZrJDlE1MP09tdTI53CUDgKycXs2
         Pp4ooHVji3OkFy6jMTtLqO8hKL7m3PCctY4yXO/i07MJYp3UTcTYn3YDv1QCJkMfxpmS
         K8iQ==
X-Gm-Message-State: AO0yUKVLYsfMqkzJZoJnlQG3cO7qf7PqGNEkMLIpKKwVh5tHs/DZpJP+
        NeINghgD8LYQ9Xe9PwX7S0JuFg==
X-Google-Smtp-Source: AK7set/T2POVnIBDD3cCjQ6V6AuAcgZrmYFyZYwurwlKmZVmv5S1z9Nv09xWZAyt5AlNpv75YtZurA==
X-Received: by 2002:a05:6e02:18cb:b0:310:c6d3:f4de with SMTP id s11-20020a056e0218cb00b00310c6d3f4demr19111ilu.22.1674767558124;
        Thu, 26 Jan 2023 13:12:38 -0800 (PST)
Received: from localhost ([136.37.131.79])
        by smtp.gmail.com with ESMTPSA id i21-20020a02c615000000b0039e8f997ad6sm799222jan.32.2023.01.26.13.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:12:36 -0800 (PST)
Date:   Thu, 26 Jan 2023 15:12:35 -0600
From:   "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] vhost: improve livepatch switching for heavily
 loaded vhost worker kthreads
Message-ID: <Y9LswwnPAf+nOVFG@do-x1extreme>
References: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
 <Y9KyVKQk3eH+RRse@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9KyVKQk3eH+RRse@alley>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jan 26, 2023 at 06:03:16PM +0100, Petr Mladek wrote:
> On Fri 2023-01-20 16:12:20, Seth Forshee (DigitalOcean) wrote:
> > We've fairly regularaly seen liveptches which cannot transition within kpatch's
> > timeout period due to busy vhost worker kthreads.
> 
> I have missed this detail. Miroslav told me that we have solved
> something similar some time ago, see
> https://lore.kernel.org/all/20220507174628.2086373-1-song@kernel.org/

Interesting thread. I had thought about something along the lines of the
original patch, but there are some ideas in there that I hadn't
considered.

> Honestly, kpatch's timeout 1 minute looks incredible low to me. Note
> that the transition is tried only once per minute. It means that there
> are "only" 60 attempts.
> 
> Just by chance, does it help you to increase the timeout, please?

To be honest my test setup reproduces the problem well enough to make
KLP wait significant time due to vhost threads, but it seldom causes it
to hit kpatch's timeout.

Our system management software will try to load a patch tens of times in
a day, and we've seen real-world cases where patches couldn't load
within kpatch's timeout for multiple days. But I don't have such an
environment readily accessible for my own testing. I can try to refine
my test case and see if I can get it to that point.

> This low timeout might be useful for testing. But in practice, it does
> not matter when the transition is lasting one hour or even longer.
> It takes much longer time to prepare the livepatch.

Agreed. And to be clear, we cope with the fact that patches may take
hours or even days to get applied in some cases. The patches I sent are
just about improving the only case I've identified which has lead to
kpatch failing to load a patch for a day or longer.

Thanks,
Seth
