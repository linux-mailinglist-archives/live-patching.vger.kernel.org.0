Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA0046CA4E
	for <lists+live-patching@lfdr.de>; Wed,  8 Dec 2021 02:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhLHBzH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Dec 2021 20:55:07 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54011 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234950AbhLHBzG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Dec 2021 20:55:06 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 672DD5C01C1;
        Tue,  7 Dec 2021 20:51:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 07 Dec 2021 20:51:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
        message-id:subject:from:to:cc:in-reply-to:references
        :content-type:date:mime-version:content-transfer-encoding; s=
        fm3; bh=KXxQxvJi5hLHGPEgEvHaIr8Gi/xSJXFASbh3p1HBoFg=; b=M8vaJWVE
        Aj8Eke8V7afQ4XG3uyZ47Ey5sd/ZOYJ1UHalQY6WwuJ16makLx5v2lKrW+BST0Uv
        NTZiCWYom2Z1czTN8cBmkRp1CFCRBgf3N2hBWwd2VcczcRPGtkpY3jMBdRBAh1pI
        ZM47ok5xSR4XlN10HUcI/YugOxHRSftcfc1FvWo6ACT0oMUQCCLwGUjXQUrWNXhX
        N+OYZWFR6uuC3N7fvnZTyjNKI7M9iuk/y2aWMbWv+oV/qpzMze5m0DTnjhd6eLaj
        CBd06t75ulzZBUWD3YUJJJIXmxkrlpipBbfKEboTbeZwQtaDAb2dsc7FTVGpvYhS
        2+EXp8ULZfQCRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=KXxQxvJi5hLHGPEgEvHaIr8Gi/xSJXFASbh3p1HBo
        Fg=; b=b0bcdildhfUIiW0DEDyFGcgMloIB/+QUh4l3Z92u0rG01LuR1fTHtECsk
        auaUoOryTneFBQlywawCwCo2wJCFIjFAnxsSgrC7MilN+r3+rMAKQsek4l67Rype
        tdwDkoiqctTtarCjcJIN0Zwe8Il7BvINWc/8YOwFnv6P3Tk7+mw+4Z1Lr5vit1kE
        3hSrmaYppjMAwKHDzkfdiKQQ9Ksq2ggAhXDmN8RgBfXIeVYjMq77EOuKC5K5SsSc
        CLnBjbgPb0wBw4H3CMVf/85i7IRIZpFrGeiZIVzmNpcR4Mwn01fgTTvPmU/981eg
        PY+EqBRN51VI767nU9fcLrfbUSDWw==
X-ME-Sender: <xms:pg-wYcCs-dT9mvD4PqQFHq8rSugRt2ptQXJIiSEJUSSKquAGONb7hg>
    <xme:pg-wYegpeQhKDweIc_r7xgvZ9QmHKvhBTEjUzsZhkWEBktYGdaZ3bbaTKiFtKy0DV
    pmb2hCxKvVV49LECQ>
X-ME-Received: <xmr:pg-wYfmffUDY1bHGqPMdUZolAcS6p0BK7qPpTVjKLlwhzK5C4f2jG-aTkVBz7dF7n3O2e1d6FA9DT7RzxlzJSlabUg_qJCgxV4CrfAlr57z_b-2bcYoE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjeejgddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdduhedmnecujfgurhepkffuhffvjghftgffgggfgfesthekredttder
    jeenucfhrhhomheptfhushhsvghllhcuvehurhhrvgihuceorhhushgtuhhrsehruhhssh
    gvlhhlrdgttgeqnecuggftrfgrthhtvghrnhephfduleeuffdvhfehhedtkeehhfefkedt
    vdeuueekteefffdttdetgfeiveehfeegnecuffhomhgrihhnpehgihhthhhusgdrtghomh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehruhhs
    tghurhesrhhushhsvghllhdrtggt
X-ME-Proxy: <xmx:pg-wYSw_pv89zL6eLWn8PJaNXXQiK11j1yW9YL2n29ws2ZoJ0hwZpA>
    <xmx:pg-wYRQyXtcj8cABZZfgYeWz8w2bCSGa69Yk0JON6FjHr3GZjly7dw>
    <xmx:pg-wYdbmb1dEeo-hhFLSVFvtV7a9gIcq8OSAvt_NAw1WwZcu4vmEBQ>
    <xmx:pw-wYaJIXW14n8IE2qPDr00lz3kRb5dcTT75mMGFSZ3P6nUg4apWSg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Dec 2021 20:51:32 -0500 (EST)
Message-ID: <25d35b916e87ed7a71ebc6528259e2f0ed390cb2.camel@russell.cc>
Subject: Re: [PATCH] powerpc/module_64: Fix livepatching for RO modules
From:   Russell Currey <ruscur@russell.cc>
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     jniethe5@gmail.com, naveen.n.rao@linux.vnet.ibm.com,
        mpe@ellerman.id.au, christophe.leroy@csgroup.eu,
        live-patching@vger.kernel.org
In-Reply-To: <d9d9ef2d-4aaa-7d8b-d15e-0452a355c5cf@redhat.com>
References: <20211123081520.18843-1-ruscur@russell.cc>
         <d9d9ef2d-4aaa-7d8b-d15e-0452a355c5cf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date:   Wed, 08 Dec 2021 11:51:27 +1000
MIME-Version: 1.0
User-Agent: Evolution 3.42.2 
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 2021-12-07 at 09:44 -0500, Joe Lawrence wrote:
> On 11/23/21 3:15 AM, Russell Currey wrote:
> 
> [[ cc += livepatching list ]]
> 
> Hi Russell,
> 
> Thanks for writing a minimal fix for stable / backporting.  As I
> mentioned on the github issue [1], this avoided the crashes I
> reported
> here and over on kpatch github [2].  I wasn't sure if this is the
> final
> version for stable, but feel free to add my:
> 
> Tested-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks Joe, as per the discussions on GitHub I think we're fine to use
this patch for a fix for stable (unless there's new issues found or
additional community feedback etc).

> 
> [1] https://github.com/linuxppc/issues/issues/375
> [2] https://github.com/dynup/kpatch/issues/1228
> 

