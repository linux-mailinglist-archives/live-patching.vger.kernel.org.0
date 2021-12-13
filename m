Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDDE473827
	for <lists+live-patching@lfdr.de>; Mon, 13 Dec 2021 23:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242188AbhLMW6r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 13 Dec 2021 17:58:47 -0500
Received: from mail-qt1-f172.google.com ([209.85.160.172]:44823 "EHLO
        mail-qt1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240451AbhLMW6p (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 13 Dec 2021 17:58:45 -0500
Received: by mail-qt1-f172.google.com with SMTP id a2so16790342qtx.11;
        Mon, 13 Dec 2021 14:58:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eLGNpG7chlHMEMwRu47zZoAoTJegvANhf4Imkmgcq+M=;
        b=jklnVk+dC+qpHusLKS5Zjnt680yNDREhpdeFV0eJ2+/pyS5imVoTNJrSqT105u9HJQ
         1sXswLiBkLXJkSfQs10XZCeDEMEU8sle9MPss9HtYFlXfdS5e+n3P9YVNJsk/FnJZfoc
         h4jYsgGvSSFNRITI5MJqQuN2k1RnQiTV1i3nB41J1DdgD+MJRzzun/ruaF4562P9OTHB
         yl+ELkQLrFK/+GBriU29JTUJR82Id4ZlbR804e+HqdIEa2Rnuxh/Dik5QVKzW2BC2OzJ
         j2Uj2T0GyNRC2x37kxgybyouOb7PE6HP2GGbk5fyNEwygXeo0rb4TNenzw1yAKSSS2qR
         rboA==
X-Gm-Message-State: AOAM532GoxyHw/YvlSqvvrhRlc4iUQPcfZvPmfaVWyJ56XvvkYgieq7N
        FsWdkXwRZltfGDi1a0NHoeQ=
X-Google-Smtp-Source: ABdhPJxLXAuCq1qYwxa/R4mMsQLETh9qT7nm1pMxfuMkop3nUMdoVXjuVN2UWf73VEPzdBHn+Zp07A==
X-Received: by 2002:ac8:5c16:: with SMTP id i22mr1628787qti.641.1639436324755;
        Mon, 13 Dec 2021 14:58:44 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-005.fbsv.net. [2a03:2880:20ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id t9sm6575264qkp.110.2021.12.13.14.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 14:58:44 -0800 (PST)
Date:   Mon, 13 Dec 2021 14:58:38 -0800
From:   David Vernet <void@manifault.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     pmladek@suse.com, linux-doc@vger.kernel.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        corbet@lwn.net, yhs@fb.com, songliubraving@fb.com
Subject: Re: [PATCH] livepatch: Fix leak on klp_init_patch_early failure path
Message-ID: <YbfQHjoUO5GTvImR@dev0025.ash9.facebook.com>
References: <20211213191734.3238783-1-void@manifault.com>
 <20211213201022.dhalhtc2bpey55gh@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213201022.dhalhtc2bpey55gh@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Josh Poimboeuf <jpoimboe@redhat.com> wrote on Mon [2021-Dec-13 12:10:22 -0800]:
> The patch description needs a few tweaks.  In the kernel we don't use
> Markdown for patch descriptions.
> 
> A function can be postfixed with a trailing pair of parentheses, like
> klp_enable_patch().
> 
> Other symbols can be enclosed with single quotes, like 'struct
> klp_object'.
> 
> I'd also recommend avoiding the excessive use of "we", in favor of more
> imperative-type language.
> 
> See Documentation/process/submitting-patches.rst for more details.  It's
> also a good idea to look at some kernel commit logs to get a general
> idea of the kernel patch description style.

Understood, I'll take a read through and re-submit the patch to honor the
norms for Linux kernel patches. My sincere apologies for the noise, and
thank you for the positive and constructive suggestions.

> I don't think the fix will be quite that simple.  For example, if
> klp_init_patch_early() fails, that means try_module_get() hasn't been
> done, so klp_free_patch_finish() will wrongly do a module_put().

Ugh, good point and thank you for catching that. Another problem with the
current patch is that we'll call kobject_put() on the patch even if we
never call kobject_init on the patch due to patch->objs being NULL.

Perhaps we should pull try_module_get() and the NULL check for patch->objs
out of klp_init_patch_early()? It feels a bit more intuitive to me if
klp_init_patch_early() were only be responsible for initializing kobjects
for the patch and its objects / funcs anyways.

Testing it locally seems to work fine. Let me know if this sounds
reasonable to you, and I'll send out a v2 patch with the fixes to both the
patch description, and logic.

- David
