Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2FD67B95A
	for <lists+live-patching@lfdr.de>; Wed, 31 Jul 2019 07:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbfGaF7T (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 31 Jul 2019 01:59:19 -0400
Received: from conssluserg-01.nifty.com ([210.131.2.80]:37145 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfGaF7T (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 31 Jul 2019 01:59:19 -0400
X-Greylist: delayed 11287 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2019 01:59:17 EDT
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id x6V5x46Z020578;
        Wed, 31 Jul 2019 14:59:07 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com x6V5x46Z020578
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564552747;
        bh=pb22LnSUq/I5TuyMMV/ed22byQ1Vd9m60c55OfeuMhI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=E+l61C0K8NMre7x8Ip9zckBBpPk4LsH/enunjZIfdV1+ykHT3zfDPAmQn3a1B3PRh
         zFboEnr4Xgt/jMyhawQUOQqTpltUAbV4Q8FXzV6f+YE0+lqIrFze1+weknyaneA2hC
         r97Yxqu+AvkD5zsiSv9LEkkWgGy3JBXPO0q84NeW+OBoO4DaZM/A8kqoBwCY/7n20T
         55VjFeR7oDTesi6qJhAXv32mPpgSzremGe0tfEJ9svL7YxC8arDLzfGTsRPfue26hy
         2wOvMAlxtKM4v2p13bxzNZ5dxDGc+4LFe8CKzbI61kM+omKfrJt8pyNGXgFVA4PBms
         jXFn1aqG4YCrA==
X-Nifty-SrcIP: [209.85.222.41]
Received: by mail-ua1-f41.google.com with SMTP id 34so26500080uar.8;
        Tue, 30 Jul 2019 22:59:06 -0700 (PDT)
X-Gm-Message-State: APjAAAW7XurefAVn10eb0lliGeWdXoCGO4CE/l2m1t0QTOPqQe5uLstu
        vCl53Mwc5f27h0bdpJ97AUMLCJ3QC9dS2hAw4oQ=
X-Google-Smtp-Source: APXvYqzUIBQ+X2Qhsv3t3MCmTOaywit/O1KFV5D0RgL5oi4OIjK2ALX40Vb/IhgnVqtvrl3BHdGPzv8CCw0HpFG5Wlk=
X-Received: by 2002:ab0:70d9:: with SMTP id r25mr47885061ual.109.1564552743799;
 Tue, 30 Jul 2019 22:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <20190509143859.9050-7-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-7-joe.lawrence@redhat.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed, 31 Jul 2019 14:58:27 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
Message-ID: <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000086ed9a058ef3d24e"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

--00000000000086ed9a058ef3d24e
Content-Type: text/plain; charset="UTF-8"

Hi Joe,


On Thu, May 9, 2019 at 11:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>
> From: Miroslav Benes <mbenes@suse.cz>
>
> Currently, livepatch infrastructure in the kernel relies on
> MODULE_INFO(livepatch, "Y") statement in a livepatch module. Then the
> kernel module loader knows a module is indeed livepatch module and can
> behave accordingly.
>
> klp-convert, on the other hand relies on LIVEPATCH_* statement in the
> module's Makefile for exactly the same reason.
>
> Remove dependency on modinfo and generate MODULE_INFO flag
> automatically in modpost when LIVEPATCH_* is defined in the module's
> Makefile. Generate a list of all built livepatch modules based on
> the .livepatch file and store it in (MODVERDIR)/livepatchmods. Give
> this list as an argument for modpost which will use it to identify
> livepatch modules.
>
> As MODULE_INFO is no longer needed, remove it.


I do not understand this patch.
This makes the implementation so complicated.

I think MODULE_INFO(livepatch, "Y") is cleaner than
LIVEPATCH_* in Makefile.


How about this approach?


[1] Make modpost generate the list of livepatch modules.
    (livepatch-modules)

[2] Generate Symbols.list in scripts/Makefile.modpost
    (vmlinux + modules excluding livepatch-modules)

[3] Run klp-convert for modules in livepatch-modules.


If you do this, you can remove most of the build system hacks
can't you?


I attached an example implementation for [1].

Please check whether this works.

Thanks.



-- 
Best Regards
Masahiro Yamada

--00000000000086ed9a058ef3d24e
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-livepatch-make-modpost-generate-the-list-of-livepatc.patch"
Content-Disposition: attachment; 
	filename="0001-livepatch-make-modpost-generate-the-list-of-livepatc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jyqu4zy00>
X-Attachment-Id: f_jyqu4zy00

RnJvbSA4NTU3MTQzMGFhMTJjZDE5YTc1Y2JjODU2ZGExMDkyMTk5ODc2ZTZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXNhaGlybyBZYW1hZGEgPHlhbWFkYS5tYXNhaGlyb0Bzb2Np
b25leHQuY29tPgpEYXRlOiBXZWQsIDMxIEp1bCAyMDE5IDE0OjUxOjI5ICswOTAwClN1YmplY3Q6
IFtQQVRDSF0gbGl2ZXBhdGNoOiBtYWtlIG1vZHBvc3QgZ2VuZXJhdGUgdGhlIGxpc3Qgb2YgbGl2
ZXBhdGNoCiBtb2R1bGVzCgpSZXZlcnNlIHRoZSBsaXZlcGF0Y2gtbW9kdWxlcyBkaXJlY3Rpb24u
CgpUaGUgbW9kcG9zdCBnZW5lcmF0ZXMgdGhlIGxpdmVwYXRjaC1tb2R1bGVzIGZpbGUgaW5zdGVh
ZCBvZgpNYWtlZmlsZSBmZWVkaW5nIGl0IHRvIG1vZHBvc3QuCgpUaGUgaW1wbGVtZW50YXRpb24g
anVzdCBtaW1pY3Mgd3JpdGVfZHVtcCgpLgoKU2lnbmVkLW9mZi1ieTogTWFzYWhpcm8gWWFtYWRh
IDx5YW1hZGEubWFzYWhpcm9Ac29jaW9uZXh0LmNvbT4KLS0tCiBzY3JpcHRzL01ha2VmaWxlLm1v
ZHBvc3QgfCAgMyArKy0KIHNjcmlwdHMvbW9kL21vZHBvc3QuYyAgICB8IDI4ICsrKysrKysrKysr
KysrKysrKysrKysrKysrLS0KIHNjcmlwdHMvbW9kL21vZHBvc3QuaCAgICB8ICAxICsKIDMgZmls
ZXMgY2hhbmdlZCwgMjkgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQg
YS9zY3JpcHRzL01ha2VmaWxlLm1vZHBvc3QgYi9zY3JpcHRzL01ha2VmaWxlLm1vZHBvc3QKaW5k
ZXggOTJlZDAyZDdjZDVlLi5jODg0YjdiNzA5Y2EgMTAwNjQ0Ci0tLSBhL3NjcmlwdHMvTWFrZWZp
bGUubW9kcG9zdAorKysgYi9zY3JpcHRzL01ha2VmaWxlLm1vZHBvc3QKQEAgLTU2LDcgKzU2LDgg
QEAgTU9EUE9TVCA9IHNjcmlwdHMvbW9kL21vZHBvc3QJCQkJCQlcCiAJJChpZiAkKEtCVUlMRF9F
WFRNT0QpLCQoYWRkcHJlZml4IC1lICwkKEtCVUlMRF9FWFRSQV9TWU1CT0xTKSkpCVwKIAkkKGlm
ICQoS0JVSUxEX0VYVE1PRCksLW8gJChtb2R1bGVzeW1maWxlKSkJCQlcCiAJJChpZiAkKENPTkZJ
R19TRUNUSU9OX01JU01BVENIX1dBUk5fT05MWSksLC1FKQkJCVwKLQkkKGlmICQoS0JVSUxEX01P
RFBPU1RfV0FSTiksLXcpCisJJChpZiAkKEtCVUlMRF9NT0RQT1NUX1dBUk4pLC13KQkJCQkJXAor
CSQoaWYgJChDT05GSUdfTElWRVBBVENIKSwtbCBsaXZlcGF0Y2gtbW9kdWxlcykKIAogaWZkZWYg
TU9EUE9TVF9WTUxJTlVYCiAKZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL21vZHBvc3QuYyBiL3Nj
cmlwdHMvbW9kL21vZHBvc3QuYwppbmRleCAzZTZkMzZkZGZjZGYuLmUzZjYzN2YyMjVlNCAxMDA2
NDQKLS0tIGEvc2NyaXB0cy9tb2QvbW9kcG9zdC5jCisrKyBiL3NjcmlwdHMvbW9kL21vZHBvc3Qu
YwpAQCAtMTk3Niw2ICsxOTc2LDEwIEBAIHN0YXRpYyB2b2lkIHJlYWRfc3ltYm9scyhjb25zdCBj
aGFyICptb2RuYW1lKQogCQlsaWNlbnNlID0gZ2V0X25leHRfbW9kaW5mbygmaW5mbywgImxpY2Vu
c2UiLCBsaWNlbnNlKTsKIAl9CiAKKwkvKiBMaXZlcGF0Y2ggbW9kdWxlcyBoYXZlIHVucmVzb2x2
ZWQgc3ltYm9scyByZXNvbHZlZCBieSBrbHAtY29udmVydCAqLworCWlmIChnZXRfbW9kaW5mbygm
aW5mbywgImxpdmVwYXRjaCIpKQorCQltb2QtPmxpdmVwYXRjaCA9IDE7CisKIAlmb3IgKHN5bSA9
IGluZm8uc3ltdGFiX3N0YXJ0OyBzeW0gPCBpbmZvLnN5bXRhYl9zdG9wOyBzeW0rKykgewogCQlz
eW1uYW1lID0gcmVtb3ZlX2RvdChpbmZvLnN0cnRhYiArIHN5bS0+c3RfbmFtZSk7CiAKQEAgLTIx
MTgsNyArMjEyMiw3IEBAIHN0YXRpYyBpbnQgY2hlY2tfZXhwb3J0cyhzdHJ1Y3QgbW9kdWxlICpt
b2QpCiAJCWNvbnN0IGNoYXIgKmJhc2VuYW1lOwogCQlleHAgPSBmaW5kX3N5bWJvbChzLT5uYW1l
KTsKIAkJaWYgKCFleHAgfHwgZXhwLT5tb2R1bGUgPT0gbW9kKSB7Ci0JCQlpZiAoaGF2ZV92bWxp
bnV4ICYmICFzLT53ZWFrKSB7CisJCQlpZiAoaGF2ZV92bWxpbnV4ICYmICFzLT53ZWFrICYmICFt
b2QtPmxpdmVwYXRjaCkgewogCQkJCWlmICh3YXJuX3VucmVzb2x2ZWQpIHsKIAkJCQkJd2Fybigi
XCIlc1wiIFslcy5rb10gdW5kZWZpbmVkIVxuIiwKIAkJCQkJICAgICBzLT5uYW1lLCBtb2QtPm5h
bWUpOwpAQCAtMjQyOSw2ICsyNDMzLDIwIEBAIHN0YXRpYyB2b2lkIHdyaXRlX2R1bXAoY29uc3Qg
Y2hhciAqZm5hbWUpCiAJZnJlZShidWYucCk7CiB9CiAKK3N0YXRpYyB2b2lkIHdyaXRlX2xpdmVw
YXRjaF9tb2R1bGVzKGNvbnN0IGNoYXIgKmZuYW1lKQoreworCXN0cnVjdCBidWZmZXIgYnVmID0g
eyB9OworCXN0cnVjdCBtb2R1bGUgKm1vZDsKKworCWZvciAobW9kID0gbW9kdWxlczsgbW9kOyBt
b2QgPSBtb2QtPm5leHQpIHsKKwkJaWYgKG1vZC0+bGl2ZXBhdGNoKQorCQkJYnVmX3ByaW50Zigm
YnVmLCAiJXNcbiIsIG1vZC0+bmFtZSk7CisJfQorCisJd3JpdGVfaWZfY2hhbmdlZCgmYnVmLCBm
bmFtZSk7CisJZnJlZShidWYucCk7Cit9CisKIHN0cnVjdCBleHRfc3ltX2xpc3QgewogCXN0cnVj
dCBleHRfc3ltX2xpc3QgKm5leHQ7CiAJY29uc3QgY2hhciAqZmlsZTsKQEAgLTI0NDAsMTMgKzI0
NTgsMTQgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQogCXN0cnVjdCBidWZmZXIg
YnVmID0geyB9OwogCWNoYXIgKmtlcm5lbF9yZWFkID0gTlVMTCwgKm1vZHVsZV9yZWFkID0gTlVM
TDsKIAljaGFyICpkdW1wX3dyaXRlID0gTlVMTCwgKmZpbGVzX3NvdXJjZSA9IE5VTEw7CisJY2hh
ciAqbGl2ZXBhdGNoX21vZHVsZXMgPSBOVUxMOwogCWludCBvcHQ7CiAJaW50IGVycjsKIAlpbnQg
bjsKIAlzdHJ1Y3QgZXh0X3N5bV9saXN0ICpleHRzeW1faXRlcjsKIAlzdHJ1Y3QgZXh0X3N5bV9s
aXN0ICpleHRzeW1fc3RhcnQgPSBOVUxMOwogCi0Jd2hpbGUgKChvcHQgPSBnZXRvcHQoYXJnYywg
YXJndiwgImk6STplOm1uc1Q6bzphd0UiKSkgIT0gLTEpIHsKKwl3aGlsZSAoKG9wdCA9IGdldG9w
dChhcmdjLCBhcmd2LCAiaTpJOmU6bDptbnNUOm86YXdFIikpICE9IC0xKSB7CiAJCXN3aXRjaCAo
b3B0KSB7CiAJCWNhc2UgJ2knOgogCQkJa2VybmVsX3JlYWQgPSBvcHRhcmc7CkBAIC0yNDYzLDYg
KzI0ODIsOSBAQCBpbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJCQlleHRzeW1faXRl
ci0+ZmlsZSA9IG9wdGFyZzsKIAkJCWV4dHN5bV9zdGFydCA9IGV4dHN5bV9pdGVyOwogCQkJYnJl
YWs7CisJCWNhc2UgJ2wnOgorCQkJbGl2ZXBhdGNoX21vZHVsZXMgPSBvcHRhcmc7CisJCQlicmVh
azsKIAkJY2FzZSAnbSc6CiAJCQltb2R2ZXJzaW9ucyA9IDE7CiAJCQlicmVhazsKQEAgLTI1MzUs
NiArMjU1Nyw4IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikKIAl9CiAJaWYgKGR1
bXBfd3JpdGUpCiAJCXdyaXRlX2R1bXAoZHVtcF93cml0ZSk7CisJaWYgKGxpdmVwYXRjaF9tb2R1
bGVzKQorCQl3cml0ZV9saXZlcGF0Y2hfbW9kdWxlcyhsaXZlcGF0Y2hfbW9kdWxlcyk7CiAJaWYg
KHNlY19taXNtYXRjaF9jb3VudCAmJiBzZWNfbWlzbWF0Y2hfZmF0YWwpCiAJCWZhdGFsKCJtb2Rw
b3N0OiBTZWN0aW9uIG1pc21hdGNoZXMgZGV0ZWN0ZWQuXG4iCiAJCSAgICAgICJTZXQgQ09ORklH
X1NFQ1RJT05fTUlTTUFUQ0hfV0FSTl9PTkxZPXkgdG8gYWxsb3cgdGhlbS5cbiIpOwpkaWZmIC0t
Z2l0IGEvc2NyaXB0cy9tb2QvbW9kcG9zdC5oIGIvc2NyaXB0cy9tb2QvbW9kcG9zdC5oCmluZGV4
IDg0NTNkNmFjMmY3Ny4uMmFjZmFhZTA2NGVjIDEwMDY0NAotLS0gYS9zY3JpcHRzL21vZC9tb2Rw
b3N0LmgKKysrIGIvc2NyaXB0cy9tb2QvbW9kcG9zdC5oCkBAIC0xMTgsNiArMTE4LDcgQEAgc3Ry
dWN0IG1vZHVsZSB7CiAJaW50IHNraXA7CiAJaW50IGhhc19pbml0OwogCWludCBoYXNfY2xlYW51
cDsKKwlpbnQgbGl2ZXBhdGNoOwogCXN0cnVjdCBidWZmZXIgZGV2X3RhYmxlX2J1ZjsKIAljaGFy
CSAgICAgc3JjdmVyc2lvblsyNV07CiAJaW50IGlzX2RvdF9vOwotLSAKMi4xNy4xCgo=
--00000000000086ed9a058ef3d24e--
