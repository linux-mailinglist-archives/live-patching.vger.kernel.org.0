Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 107C9552AC7
	for <lists+live-patching@lfdr.de>; Tue, 21 Jun 2022 08:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345543AbiFUGHH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jun 2022 02:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiFUGHF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jun 2022 02:07:05 -0400
X-Greylist: delayed 731 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 20 Jun 2022 23:06:59 PDT
Received: from bufferz9.csloxinfo.com (bufferz.csloxinfo.com [203.146.237.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63BAB2018C;
        Mon, 20 Jun 2022 23:06:59 -0700 (PDT)
Received: from mailx1-13.cslox.com (unknown [10.20.140.13])
        by bufferz9.csloxinfo.com (Postfix) with ESMTP id 5A85B2363E38;
        Tue, 21 Jun 2022 12:54:47 +0700 (ICT)
IronPort-SDR: vhR7/MXbkCdA16SZwtt4atABoFu5lIOTuBscHM41VBpXJdDfCd6OnKBHDoeQCJ2VSWT5w+HgiO
 dCu80+a3enU93pU9yXa/zJLTcC+UneKPw=
IronPort-Data: =?us-ascii?q?A9a23=3AW3y846pYj3y+B1wm/t1K1hVl9iZeBmLwYBIvg?=
 =?us-ascii?q?KrLsJaIsI4StFCztgarIBnSa/bZYjTyft5yboi2/BsBvpfUmt4wQVA5+SlhF?=
 =?us-ascii?q?SIa+ePIVI+TRqvS04F+DeWdFhM+s5hAAjX4wUldokb0/n9B65Dt8itx07+mX?=
 =?us-ascii?q?L35BLKWMyx9X1Y9Gj0gghI6wb9/iYlt2IDrDwSIsNL0gsveJF78hm4ubDtKu?=
 =?us-ascii?q?/7dpUM9pun2tRMZokc6NKJCs1LpnnUICI4SePOqJHziT4gIRuO3Hr6RzLyw8?=
 =?us-ascii?q?m7D0Q0qD9epzuTyfkEQG+eAJwmFiiMMCu6phR0b/n4+1aMyNfw9b0ZLimzUz?=
 =?us-ascii?q?4ovkYsd6cK9EF57MLfNleIRVwhjPxt/ZaAWqqXaJXWfsNCIyxyUenTh9PxiE?=
 =?us-ascii?q?UUqMNBK4e1wG2xPqaQVJT1UNUKDiuu6zaiBR/Fol9gkKMW3booTtms5lmPWE?=
 =?us-ascii?q?PUvQJXKQqGM7thdhW9iisdLFPfYRswYdTs2MkmbOkcRYQ9MBcJshvqsi1n+b?=
 =?us-ascii?q?yZc+QCcqqcA6mTOyBB8jer2O93Pd93WHchYkxrKpm/C+GilUBgWOMbFkmiA+?=
 =?us-ascii?q?3OowODVlCX3VZIZEKCj9+BnxlaUwzVLWhERUFK6p9i/i1K/AogBcxZJonJz8?=
 =?us-ascii?q?6Vipla2StTdXgGjpCLWtBArXdcNQfYx7xuAy/aJ7guUboTeouWtU/R78p5sL?=
 =?us-ascii?q?dAW/gXRxYmxW2Y26OT9pU+1r994kxvjYUD5EkdfPUfofSNdizXSiNlbYiDnF?=
 =?us-ascii?q?r6PI4bt5jHBIgwc9hjRxMQIaxr/uuZQv0mz1QivbztBPfElRCZtjuncdjrNA?=
 =?us-ascii?q?g+U+OeYi4KUBVjztZ6sLa6cR1iF+nceks6S4fAFCYyWlTKABu4KGdlF5d7fb?=
 =?us-ascii?q?3uG3AIpRsV/sW3yk5KgVdg4DDVWLUxiNdsCZRfzYUTT4FkAopRUORNGaIcsO?=
 =?us-ascii?q?N7rV5p3kfmI+dPNE6q8gsB1SoN6dBWA8Cx0TVCdwGHo1VUyjuc1NP+zatqlB?=
 =?us-ascii?q?GoyF6l4zTzzWvkCl7Umrgg/w23UbY71xg6il7GZYRa9SLELN3OQYOc/4LjCp?=
 =?us-ascii?q?gG929ZeM8+HzR9FWevySjfZ7MgfIDgiLH41ArjopdEReuPrCglrHmczAv/Vz?=
 =?us-ascii?q?LUJZYJ42ahY/s/T5nanRkNZxVzkmVXZJg7MYH0LQLzuQb5hon8hey8hJ1Cl3?=
 =?us-ascii?q?z4ke4nHxKMecYYnOLgm88R9wvNuCfoIYcONBrJIUDuv0zAca4Tt6ZRpdTy1i?=
 =?us-ascii?q?g+UeSmoej4ye9hnXQOh0tvleBb/sTMCCyOfq8Qzufuj2xndTJ5FQB5tZO7Sa?=
 =?us-ascii?q?fSy3xauvGIQnO9pRGPWLdRJPkbh6o5nL2r2lPBfC8UNNxiG3jKG3AaXBxgwu?=
 =?us-ascii?q?+bAuck2/cPPiKTCqJ2me8N0BE1dHHLz87m5PC3e83Cyh4RHVY6gZz/YEmPp+?=
 =?us-ascii?q?aOvY81LwPS6NPAGkFtMrox9DfBtycoW7Nvmvbtd0hhpWnPMdViwFqlnJ1GY0?=
 =?us-ascii?q?tNCuaxKwPlCtGOeREuU+91bO67PN8LjE1k5OgU5KOCdvdkWkyPb6PMuCFv66?=
 =?us-ascii?q?SVt+7zBV0hOVzGUjDFGLb9xOas7weoroskQrQqylnICN9+cjykS7WOANH0PT?=
 =?us-ascii?q?qg18IoTBoTrhxgD1FFDe9rbECCeyJCJZdJkLEkuLTKSibbDjK8azU3HG1IyE?=
 =?us-ascii?q?3bK9fRdnpULuwpHzUQCKk6HncDJwPM6tDVW/zo2RQl90BRO2Ot/N21qPEQzL?=
 =?us-ascii?q?qKLlx9jgM9YUmynEhldBRqf0lLwwlAOkSvSSEzAfmDEMGQlI+eT9UsI6WNTf?=
 =?us-ascii?q?iRA1K+ZwW3iVHDhe8SZ9jMoVFV+g+LiRNd280vJn8XPN9ndR8I3bTP5i7e0Z?=
 =?us-ascii?q?HQBoAr9AMwxmFbvu+hj9+F1L6b8MEY4rrB9B5Gd/aoRQRuDIWdIWrdq+6ZhN?=
 =?us-ascii?q?X7Rciq73TWVA16wc89QLOCM+kj+Fs8GDtxGUx65zimmsDESCKoIKvlymJYB6?=
 =?us-ascii?q?cQPfK/DO28PvLbZpDcBmJTd6CX4mEc1QtxhnIA3J+v5aTOLHXaZrWVVkmDXp?=
 =?us-ascii?q?Y9PPW/QSccFbQLm1cir8ewGDZtFtuxwGWkq0rayo3iPNQph8jqKvQrMfaaPl?=
 =?us-ascii?q?apkxJgEt5XtG6pZDl+cN9L6W/6B9BG+9dJDcbvnNM7AuQISrlT7IwV+I7oYX?=
 =?us-ascii?q?9ln07+N2Pby1UzKvbtwSGXYh5mpCahA48m9Ru1KKoT8K3wytSqEVsjE/RoK/?=
 =?us-ascii?q?W28LZtPmd9c78y6XRG5bsb2ftkQM/9C3n1OYi5SOwgcAqL6cuHno2W2ppyx5?=
 =?us-ascii?q?rI1ueDcBIn4syW0MScCKnFOYsKWN+M9gN72jvgwkWiGLEVs6ylaPqJF?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3At2FZhKOh5KyDC8BcT9X155DYdb4zR+YMi2?=
 =?us-ascii?q?TDiHoddfUFSKalfp6V98jztCWE8wr5PUtNpTnuAtjkfZqxz+8Q3WBzB8bbYO?=
 =?us-ascii?q?CFghrPEGgK1+KLrFOQeFydygNE78ddmsBFeaDN5DNB/L/HCWeDYrEdKe28gd?=
 =?us-ascii?q?yVrNab43NpdwZmTKcI1XYCNu/XKDwAeCB2Qb4CULaM7MtOoDStPVwRc8SAH3?=
 =?us-ascii?q?EAG9POotXa/aiWEyLvU3QciTWmvHeN0vrXAhKY1hARX3dk2rE561XIlAT/++?=
 =?us-ascii?q?GKr+y74gW07R6e071m3P/ajvdTDs2FjcYYbh/2jByzWYhnU7qe+BgoveCU7k?=
 =?us-ascii?q?owmtWkmWZsAy1K0QKfQoiJm2qn5+Cg6kdn15ba8y7QvZI3m72yeNo4Y/Ax9r?=
 =?us-ascii?q?6xPCGppXbIh+sMrp6j71jpyKa/Mimw7RgVx+K4Ii2CxXDE1UbLr4Yo/gxiuM?=
 =?us-ascii?q?0lGclskbA=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0D//wBFXLFi/xGS/htaBhUBAQEBDS8?=
 =?us-ascii?q?BAQEDAwEBAQIBAQEFAQEBAQEJAQkJgUgBgTkCAQEBAQEBSgEBBgEUgRo2KxI?=
 =?us-ascii?q?YAQGNeIYBgzAVAo9wGYRwiDULAQEBAQEBAQEBDQ4wBAEBgU4BgyoCCFEBAQE?=
 =?us-ascii?q?BAQYKhGYBJTgTAQIEAQEBEgEBBQMCAQcEgQkThXVAAQwBCAEBBwEFAT8BAwF?=
 =?us-ascii?q?kARMBAQGEEAEIAUhWDRQwAlBHAQEFAYJCRQGCUgIBnXiHQodTgTMaAmWEWYM?=
 =?us-ascii?q?FgiCBOwIBAQEBAQEBAYYYF0eIHhYGgT9OgUuBBYFvPoFTgnGEDYIuBJk3BBo?=
 =?us-ascii?q?5AzQTNBKBIUUsAQgGBgcKBTIGAgwYFAQCExJTHQISDAocDlQZDA8DEgMRAQc?=
 =?us-ascii?q?CCxIIFSwIAwIDCAMCAy4CAxcJBwoDHQgKHBIQFAIEEx4LCAMZHywJAgQOA0U?=
 =?us-ascii?q?ICwoDEQQDExgLFggQBAYDCS8NKAsDFA0BBgMGAgUFAQMgAxQDBScHAyEHCyY?=
 =?us-ascii?q?NDQQcBx0DAwUmAwICGwcCAgMCBhcGAgJuCiYNCAQIBBwdJBAFAgcxBQQvAh4?=
 =?us-ascii?q?EBQYRCQIWAgYEBQIEBBYCAhIIAggnGwcWNhkBBV0GCwkhHAkgCwYFBhYDI3E?=
 =?us-ascii?q?FSA8pNTY8LyEbCoEjLCcGISlZD54igUmRLyGBOY4HYIIUnAYjBwECg06JfZV?=
 =?us-ascii?q?8GjEYg0sBEYxDhhsOCBYDkWGWbqF7hhlhOSWBWXAVgVkKJYEcUBmPAI4MNG8?=
 =?us-ascii?q?CBgsBAQMJiFmCJTCBGxaCIgEB?=
Spam_Positive: LL
X-IronPort-AV: E=Sophos;i="5.92,209,1650906000"; 
   d="scan'208";a="334246549"
Received: from unknown (HELO mail.grandexclusive.com) ([27.254.146.17])
  by mail-1.csloxinfo.com with ESMTP; 21 Jun 2022 12:54:45 +0700
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.grandexclusive.com (Postfix) with ESMTP id 816BD2849B0;
        Sun, 19 Jun 2022 17:48:22 +0700 (+07)
Received: from mail.grandexclusive.com ([127.0.0.1])
        by localhost (mail.grandexclusive.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id u8zaoDQQjiDI; Sun, 19 Jun 2022 17:48:21 +0700 (+07)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mail.grandexclusive.com (Postfix) with ESMTP id 5DB562849AB;
        Sun, 19 Jun 2022 17:48:21 +0700 (+07)
X-Virus-Scanned: amavisd-new at grandexclusive.com
Received: from mail.grandexclusive.com ([127.0.0.1])
        by localhost (mail.grandexclusive.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id htBESyOZiQPS; Sun, 19 Jun 2022 17:48:21 +0700 (+07)
Received: from [107.161.81.135] (unknown [107.161.81.135])
        by mail.grandexclusive.com (Postfix) with ESMTPSA id BDA6F2849B4;
        Sun, 19 Jun 2022 17:48:09 +0700 (+07)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Description: Mail message body
Subject: Re: Charity Giving.... ........   
To:     Recipients <account@rich129.com>
From:   "Ms G. Kailai" <account@rich129.com>
Date:   Sun, 19 Jun 2022 18:47:57 +0800
Reply-To: mail@gukaimail.com
Message-Id: <20220619104809.BDA6F2849B4@mail.grandexclusive.com>
X-Spam-Status: Yes, score=6.3 required=5.0 tests=BAYES_50,KHOP_HELO_FCRDNS,
        RCVD_IN_BL_SPAMCOP_NET,RCVD_IN_PSBL,RCVD_IN_SBL,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  1.3 RCVD_IN_BL_SPAMCOP_NET RBL: Received via a relay in
        *      bl.spamcop.net
        *      [Blocked - see <https://www.spamcop.net/bl.shtml?27.254.146.17>]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.1 RCVD_IN_SBL RBL: Received via a relay in Spamhaus SBL
        *      [203.146.237.187 listed in zen.spamhaus.org]
        *  2.7 RCVD_IN_PSBL RBL: Received via a relay in PSBL
        *      [203.146.237.187 listed in psbl.surriel.com]
        *  1.3 RCVD_IN_VALIDITY_RPBL RBL: Relay in Validity RPBL,
        *      https://senderscore.org/blocklistlookup/
        *      [203.146.237.187 listed in bl.score.senderscore.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 SPF_NONE SPF: sender does not publish an SPF Record
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  0.0 KHOP_HELO_FCRDNS Relay HELO differs from its IP's reverse DNS
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,


I want to gve out to Charities in your City, can you refer any to me? Please reply for details.


Ms. Gu Kailai
19th June
ZA1
